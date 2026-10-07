import 'package:flutter/material.dart';

class AddRecurringExpenseScreen extends StatelessWidget {
  const AddRecurringExpenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Recurring Expense'),
      ),
      body: const Center(
        child: Text(
          'Add Recurring Expense',
        ),
      ),
    );
  }
}