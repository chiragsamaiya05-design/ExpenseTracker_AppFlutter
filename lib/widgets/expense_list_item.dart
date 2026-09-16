import 'package:flutter/material.dart';

import '../models/expense_model.dart';

class ExpenseListItem extends StatelessWidget {
  final Expense expense;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ExpenseListItem({
    super.key,
    required this.expense,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        expense.title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),

      subtitle: Text(
        "${expense.category} • "
            "${expense.date.day}/"
            "${expense.date.month}/"
            "${expense.date.year}",
      ),

      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            expense.amount.toString(),
            style: const TextStyle(
              fontSize: 20,
            ),
          ),

          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: onEdit,
          ),

          const SizedBox(width: 2),

          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}