import 'package:flutter/material.dart';

import '../../models/expense_model.dart';

class RecentTransactionItem extends StatelessWidget {
  final Expense expense;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const RecentTransactionItem({
    super.key,
    required this.expense,
    required this.onEdit,
    required this.onDelete,
  });

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return Icons.restaurant_rounded;
      case 'transport':
        return Icons.directions_bus_rounded;
      case 'shopping':
        return Icons.shopping_bag_rounded;
      case 'bills':
        return Icons.receipt_long_rounded;
      case 'entertainment':
        return Icons.movie_rounded;
      case 'health':
        return Icons.medical_services_rounded;
      case 'education':
        return Icons.school_rounded;
      case 'home':
        return Icons.home_rounded;
      default:
        return Icons.category_rounded;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return Colors.orange;
      case 'transport':
        return Colors.blue;
      case 'shopping':
        return Colors.purple;
      case 'bills':
        return Colors.green;
      case 'entertainment':
        return Colors.red;
      case 'health':
        return Colors.teal;
      case 'education':
        return Colors.indigo;
      case 'home':
        return Colors.brown;
      default:
        return Colors.grey;
    }
  }

  String _getDateLabel(DateTime date) {
    final now = DateTime.now();

    final today = DateTime(now.year, now.month, now.day);
    final expenseDate = DateTime(date.year, date.month, date.day);

    final difference = today.difference(expenseDate).inDays;

    if (difference == 0) {
      return 'Today';
    }

    if (difference == 1) {
      return 'Yesterday';
    }

    if (difference > 1 && difference < 7) {
      const days = [
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
        'Saturday',
        'Sunday',
      ];

      return days[date.weekday - 1];
    }

    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final categoryColor = _getCategoryColor(expense.category);

    final expenseTitle = expense.title.isNotEmpty
        ? '${expense.title[0].toUpperCase()}${expense.title.substring(1)}'
        : '';

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onEdit,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 12,
          ),
          child: Row(
            children: [
              // Category icon.
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: categoryColor.withValues(alpha: 0.14),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getCategoryIcon(expense.category),
                  size: 20,
                  color: categoryColor,
                ),
              ),

              const SizedBox(width: 12),

              // Transaction title, category, and date.
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      expenseTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      '${expense.category} • ${_getDateLabel(expense.date)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // Expense amount.
              Text(
                '₹${expense.amount.toStringAsFixed(0)}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
              ),

              // Edit and delete menu.
              PopupMenuButton<String>(
                padding: EdgeInsets.zero,
                iconSize: 20,
                tooltip: 'Transaction options',
                icon: Icon(
                  Icons.more_vert_rounded,
                  color: colorScheme.onSurfaceVariant,
                ),
                onSelected: (value) {
                  if (value == 'edit') {
                    onEdit();
                  } else if (value == 'delete') {
                    onDelete();
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit_rounded, size: 18),
                        SizedBox(width: 10),
                        Text('Edit'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(
                          Icons.delete_outline_rounded,
                          size: 18,
                          color: colorScheme.error,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Delete',
                          style: TextStyle(
                            color: colorScheme.error,
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
      ),
    );
  }
}