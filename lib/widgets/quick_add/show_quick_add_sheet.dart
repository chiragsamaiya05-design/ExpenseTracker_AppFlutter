
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/expense_controller.dart';
import '../../models/expense_model.dart';

Future<void> showQuickAddSheet(
BuildContext context,
String category,
) async {
final titleController = TextEditingController();
final amountController = TextEditingController();

try {
await showModalBottomSheet(
context: context,
isScrollControlled: true,
useSafeArea: true,
showDragHandle: true,
builder: (sheetContext) {
return Padding(
padding: EdgeInsets.fromLTRB(
20,
8,
20,
MediaQuery.of(sheetContext).viewInsets.bottom + 20,
),
child: Column(
mainAxisSize: MainAxisSize.min,
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
'Add $category Expense',
style: Theme.of(sheetContext)
    .textTheme
    .titleLarge
    ?.copyWith(
fontWeight: FontWeight.bold,
),
),

const SizedBox(height: 20),

TextField(
controller: titleController,
autofocus: true,
textCapitalization:
TextCapitalization.sentences,
decoration: const InputDecoration(
labelText: 'Title',
hintText: 'e.g. Lunch',
border: OutlineInputBorder(),
),
),

const SizedBox(height: 14),

TextField(
controller: amountController,
keyboardType:
const TextInputType.numberWithOptions(
decimal: true,
),
decoration: const InputDecoration(
labelText: 'Amount',
hintText: '0.00',
prefixText: '₹ ',
border: OutlineInputBorder(),
),
),

const SizedBox(height: 20),

SizedBox(
width: double.infinity,
child: FilledButton(
onPressed: () async {
final title =
titleController.text.trim();

final amount = double.tryParse(
amountController.text.trim(),
);

if (title.isEmpty ||
amount == null ||
amount <= 0) {
return;
}

final expense = Expense(
title: title,
amount: amount,
category: category,
date: DateTime.now(),
);

await sheetContext
    .read<ExpenseController>()
    .addExpense(expense);

if (sheetContext.mounted) {
Navigator.pop(sheetContext);
}
},
child: const Text('Add Expense'),
),
),
],
),
);
},
);
} finally {
titleController.dispose();
amountController.dispose();
}
}

