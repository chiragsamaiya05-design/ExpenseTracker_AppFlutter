
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

import '../database/expenses_DataBase.dart';
import '../database/app_database.dart';
import '../auth/services/auth_token_storage.dart';

class ExpenseSyncResult {
final int uploaded;
final int failed;

const ExpenseSyncResult({
required this.uploaded,
required this.failed,
});
}

class ExpenseSyncException implements Exception {
final String message;

const ExpenseSyncException(this.message);

@override
String toString() => message;
}

class ExpenseSyncService {
ExpenseSyncService({
required this.baseUrl,
required this.database,
required this.tokenStorage,
http.Client? client,
}) : _client = client ?? http.Client();

final String baseUrl;
final ExpensesDatabase database;
final AuthTokenStorage tokenStorage;
final http.Client _client;

static const Uuid _uuid = Uuid();

Future<ExpenseSyncResult> syncExpenses(int userId) async {
final token = await tokenStorage.getAccessToken();

if (token == null || token.isEmpty) {
throw const ExpenseSyncException(
'Please log in before synchronizing expenses.',
);
}

final db = await database.database;

// Only local expenses that have not been synchronized are uploaded.
final pending = await db.query(
'expense',
where: 'user_id = ? AND is_synced = 0',
whereArgs: [userId],
orderBy: 'date DESC',
);

var uploaded = 0;
var failed = 0;

for (final row in pending) {
final localId = row['id'] as int;

try {
// Persist the UUID before the request, so retries reuse it.
var serverId = row['server_id'] as String?;

if (serverId == null || serverId.isEmpty) {
serverId = _uuid.v4();

await db.update(
'expense',
{'server_id': serverId},
where: 'id = ? AND user_id = ?',
whereArgs: [localId, userId],
);
}

final uri = Uri.parse('$baseUrl/expenses');

final response = await _client
    .post(
uri,
headers: {
'Content-Type': 'application/json',
'Authorization': 'Bearer $token',
},
body: jsonEncode({
'id': serverId,
'title': row['title'],
'amount': row['amount'],
'category': row['category'],
'date': _dateOnly(row['date']),
}),
)
    .timeout(const Duration(seconds: 15));

if (response.statusCode == 201 ||
response.statusCode == 200) {
final result =
jsonDecode(response.body) as Map<String, dynamic>;

final returnedId = result['id']?.toString();

if (returnedId != serverId) {
throw const ExpenseSyncException(
'The server returned an unexpected expense ID.',
);
}

await db.update(
'expense',
{'server_id': returnedId, 'is_synced': 1},
where: 'id = ? AND user_id = ? AND server_id = ?',
whereArgs: [localId, userId, serverId],
);

uploaded++;
} else {
failed++;
}
} catch (_) {
// Keep the expense pending so a later attempt can retry.
failed++;
}
}

return ExpenseSyncResult(
uploaded: uploaded,
failed: failed,
);
}

String _dateOnly(Object? value) {
if (value == null) {
throw const ExpenseSyncException(
'An expense is missing its date.',
);
}

final parsed = DateTime.parse(value.toString());

final year = parsed.year.toString().padLeft(4, '0');
final month = parsed.month.toString().padLeft(2, '0');
final day = parsed.day.toString().padLeft(2, '0');

return '$year-$month-$day';
}
}

