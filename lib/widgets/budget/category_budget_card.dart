import 'package:flutter/material.dart';

class CategoryBudgetCard extends StatelessWidget {
  const CategoryBudgetCard({
    super.key,
    required this.category,
    required this.spent,
    required this.budget,
    required this.icon,
    this.onEdit,
    this.onDelete,
  });

  final String category;
  final double spent;
  final double budget;
  final IconData icon;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  double get progress {
    if (budget <= 0) return 0;
    return (spent / budget).clamp(0.0, 1.0);
  }

  double get remaining => budget - spent;

  bool get isOverBudget => spent > budget;

  Color get categoryColor {
    switch (category.toLowerCase()) {
      case 'food':
        return const Color(0xFFFF8A65);
      case 'transport':
        return const Color(0xFF42A5F5);
      case 'shopping':
        return const Color(0xFFAB6CF5);
      case 'bills':
        return const Color(0xFFFFB74D);
      case 'entertainment':
        return const Color(0xFFEC6FA9);
      case 'health':
        return const Color(0xFF26B99A);
      case 'education':
        return const Color(0xFF5C7CFA);
      default:
        return const Color(0xFF8E8E93);
    }
  }

  Color get progressColor {
    if (isOverBudget) {
      return const Color(0xFFE74C3C);
    }

    if (progress >= 0.8) {
      return const Color(0xFFF2994A);
    }

    return categoryColor;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: categoryColor.withValues(
            alpha: isDark ? 0.35 : 0.22,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: isDark ? 0.12 : 0.025,
            ),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category header.
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: categoryColor.withValues(
                    alpha: isDark ? 0.20 : 0.12,
                  ),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: categoryColor,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Text(
                  category,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),

              PopupMenuButton<String>(
                tooltip: 'Budget options',
                icon: Icon(
                  Icons.more_vert_rounded,
                  color: colorScheme.onSurfaceVariant,
                ),
                onSelected: (value) {
                  if (value == 'edit') {
                    onEdit?.call();
                  } else if (value == 'delete') {
                    onDelete?.call();
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem<String>(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit_rounded, size: 18),
                        SizedBox(width: 10),
                        Text('Edit'),
                      ],
                    ),
                  ),
                  PopupMenuItem<String>(
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

          const SizedBox(height: 16),

          // Spending amount and budget limit.
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Flexible(
                child: Text(
                  '₹${spent.toStringAsFixed(0)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),

              const SizedBox(width: 5),

              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Text(
                    '/ ₹${budget.toStringAsFixed(0)}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 8),

              Text(
                '${(progress * 100).toStringAsFixed(0)}%',
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: progressColor,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Spending progress.
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: colorScheme.onSurface.withValues(
                alpha: isDark ? 0.10 : 0.07,
              ),
              valueColor: AlwaysStoppedAnimation<Color>(
                progressColor,
              ),
            ),
          ),

          const SizedBox(height: 10),

          // Remaining or exceeded amount.
          Row(
            children: [
              Icon(
                isOverBudget
                    ? Icons.warning_rounded
                    : Icons.account_balance_wallet_rounded,
                size: 16,
                color: progressColor,
              ),

              const SizedBox(width: 6),

              Expanded(
                child: Text(
                  isOverBudget
                      ? '₹${remaining.abs().toStringAsFixed(0)} over budget'
                      : '₹${remaining.toStringAsFixed(0)} remaining',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: progressColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}