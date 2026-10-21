
import 'package:flutter/material.dart';

import '../../auth/controllers/auth_controller.dart';
import '../../auth/services/auth_token_storage.dart';
import '../../database/app_database.dart';
import '../../database/expenses_DataBase.dart';

import '../../services/expense_sync_service.dart';
import 'package:provider/provider.dart';



class CloudSyncScreen extends StatefulWidget {
const CloudSyncScreen({super.key});

@override
State<CloudSyncScreen> createState() => _CloudSyncScreenState();
}

class _CloudSyncScreenState extends State<CloudSyncScreen> {
bool _isSyncing = false;
String _status = 'Ready to sync';
String? _lastResult;

late final ExpenseSyncService _syncService;

@override
void initState() {
super.initState();

_syncService = ExpenseSyncService(
baseUrl: 'http://127.0.0.1:8000/api/v1',
database: ExpensesDatabase(
appDatabase: AppDatabase(),
),
tokenStorage: AuthTokenStorage(),
);
}

Future<void> _checkAuthentication() async {
  final authController = context.read<AuthController>();
  final userId = authController.currentUser?.id;
  final hasToken = await AuthTokenStorage().hasAccessToken();

  if (!mounted) return;

  setState(() {
    _status = 'Authentication diagnostic';
    _lastResult =
    'App logged in: ${authController.isLoggedIn}\n'
        'Local user ID available: ${userId != null}\n'
        'Backend token saved: $hasToken';
  });
}

Future<void> _syncNow() async {
  if (_isSyncing) return;

  final authController = context.read<AuthController>();
  final userId = authController.currentUser?.id;

  if (!authController.isLoggedIn || userId == null) {
    setState(() {
      _status = 'You must log in before synchronizing.';
      _lastResult = null;
    });
    return;
  }

  setState(() {
    _isSyncing = true;
    _status = 'Synchronizing expenses...';
    _lastResult = null;
  });

  try {
    final result = await _syncService.syncExpenses(userId);

    if (!mounted) return;

    setState(() {
      _status = result.failed == 0
          ? 'Synchronization completed'
          : 'Synchronization completed with errors';

      _lastResult =
      'Uploaded: ${result.uploaded}\nFailed: ${result.failed}';
    });
  } catch (e) {
    if (!mounted) return;

    setState(() {
      _status = 'Synchronization failed';
      _lastResult = e.toString();
    });
  } finally {
    if (mounted) {
      setState(() {
        _isSyncing = false;
      });
    }
  }
}



@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: const Text('Cloud Sync & Backup'),
),
body: ListView(
padding: const EdgeInsets.all(20),
children: [
const Icon(
Icons.cloud_sync_outlined,
size: 64,
),
const SizedBox(height: 16),
Text(
_status,
textAlign: TextAlign.center,
style: Theme.of(context).textTheme.titleLarge,
),
if (_lastResult != null) ...[
const SizedBox(height: 16),
Card(
child: Padding(
padding: const EdgeInsets.all(16),
child: Text(_lastResult!),
),
),
],
const SizedBox(height: 24),
FilledButton.icon(
onPressed: _isSyncing ? null : _syncNow,
icon: _isSyncing
? const SizedBox(
width: 18,
height: 18,
child: CircularProgressIndicator(
strokeWidth: 2,
),
)
    : const Icon(Icons.sync),
label: Text(
_isSyncing ? 'Syncing...' : 'Sync Now',
),
),
const SizedBox(height: 12),
  TextButton(
    onPressed: _checkAuthentication,
    child: const Text('Check Authentication'),
  ),
const SizedBox(height: 12,),
OutlinedButton.icon(
onPressed: null,
icon: Icon(Icons.backup_outlined),
label: Text('Backup & Restore — Coming Next'),
),
const SizedBox(height: 16),
Text(
'Cloud synchronization currently uploads pending expenses. '
'Downloading cloud changes and backup restoration are not '
'implemented yet.',
style: Theme.of(context).textTheme.bodySmall,
),
],
),
);
}
}

