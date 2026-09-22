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
  static const Map<String, Color> categoryColors = {
    'Food': Colors.orange,
    'Transport': Colors.blue,
    'Shopping': Colors.purple,
    'Bills': Colors.red,
    'Entertainment': Colors.pink,
    'Health': Colors.green,
    'Education': Colors.indigo,
    'Groceries': Colors.teal,
    'Travel': Colors.cyan,
    'Gym': Colors.deepOrange,
  };

  static const Map<String, IconData> categoryIcons = {
    'Food': Icons.restaurant_rounded,
    'Transport': Icons.directions_bus_rounded,
    'Shopping': Icons.shopping_bag_rounded,
    'Bills': Icons.receipt_long_rounded,
    'Entertainment': Icons.movie_rounded,
    'Health': Icons.favorite_rounded,
    'Education': Icons.school_rounded,
    'Groceries': Icons.local_grocery_store_rounded,
    'Travel': Icons.flight_rounded,
    'Gym': Icons.fitness_center_rounded,
  };

  Color _getCategoryColor() {
    return categoryColors[expense.category] ??
        Colors.deepPurple;
  }

  IconData _getCategoryIcon() {
    return categoryIcons[expense.category] ??
        Icons.category_rounded;
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final categoryColor = _getCategoryColor();
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),

        border: Border.all(
          color: Colors.grey.shade200,
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),


      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 11),

        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    expense.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,

                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    _formatDate(expense.date),

                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade600,
                    ),
                  ),
             ],
              ),
      ),
      const SizedBox(width: 8),

            Text(
              expense.amount.toStringAsFixed(2),

              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color:  const Color(0xFFB96878),
              ),
            ),
                const SizedBox(width: 2,),

                PopupMenuButton<String>(
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

          ],
        ),
      ),
    );
  }
}