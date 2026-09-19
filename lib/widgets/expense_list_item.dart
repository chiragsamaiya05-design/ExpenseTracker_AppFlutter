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
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14,vertical: 12),

        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    expense.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    '${expense.category} • '
                        '${expense.date.day}/'
                        '${expense.date.month}/'
                        '${expense.date.year}',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 10),
            Row(
              mainAxisSize: .min,
              children: [
                Text(
                  expense.amount.toStringAsFixed(2),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 2,),

                SizedBox(
                  width: 28,
                  height: 40,
                  child: PopupMenuButton<String>(
                    padding: EdgeInsets.zero,

                    icon: const Icon(
                      Icons.more_vert,
                      size: 22,
                    ),
                    onSelected: (value) {
                      if (value == 'edit') {
                        onEdit();
                      } else if (value == 'delete') {
                        onDelete();
                      }
                    },
                    itemBuilder: (context) => const [
                      PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit),
                            SizedBox(width: 10),
                            Text('Edit'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete_outline),
                            SizedBox(width: 10),
                            Text('Delete'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}