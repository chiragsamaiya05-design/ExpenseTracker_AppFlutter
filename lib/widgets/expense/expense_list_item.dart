import 'package:flutter/material.dart';

import '../../models/expense_model.dart';

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

  static const Color _accentColor = Color(0xFF6557D9);

  static const Map<String, Color> categoryColors = {
    'Food': Color(0xFF8B6BD6),
    'Transport': Color(0xFF4F8BD6),
    'Shopping': Color(0xFF6557D9),
    'Bills': Color(0xFFD96880),
    'Entertainment': Color(0xFFB46BD6),
    'Health': Color(0xFF39A889),
    'Education': Color(0xFF6478D3),
    'Groceries': Color(0xFF48A69B),
    'Travel': Color(0xFF479BC4),
    'Gym': Color(0xFF8B78C9),
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
    return categoryColors[expense.category] ?? _accentColor;
  }

  IconData _getCategoryIcon() {
    return categoryIcons[expense.category] ?? Icons.category_rounded;
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final categoryColor = _getCategoryColor();

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.45),
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 11,
        ),
        child: Row(
          children: [
            // Category icon
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: categoryColor.withValues(alpha: 0.13),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(
                _getCategoryIcon(),
                color: categoryColor,
                size: 22,
              ),
            ),

            const SizedBox(width: 12),

            // Expense title and date
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    expense.title.isNotEmpty
                        ? '${expense.title[0].toUpperCase()}'
                        '${expense.title.substring(1)}'
                        : expense.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onSurface,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    _formatDate(expense.date),
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontSize: 11,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),

                  const SizedBox(height: 3),

                  Text(
                    expense.category,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: categoryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // Expense amount
            Text(
              '₹${expense.amount.toStringAsFixed(2)}',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: colorScheme.error,
              ),
            ),

            const SizedBox(width: 2),

            // Edit and delete menu
            PopupMenuButton<String>(
              tooltip: 'Expense options',
              padding: EdgeInsets.zero,
              icon: Icon(
                Icons.more_vert_rounded,
                size: 22,
                color: colorScheme.onSurfaceVariant,
              ),
              color: colorScheme.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              onSelected: (value) {
                if (value == 'edit') {
                  onEdit();
                } else if (value == 'delete') {
                  onDelete();
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(
                        Icons.edit_outlined,
                        color: colorScheme.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Edit',
                        style: TextStyle(
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(
                        Icons.delete_outline_rounded,
                        color: colorScheme.error,
                        size: 20,
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
    );
  }
}