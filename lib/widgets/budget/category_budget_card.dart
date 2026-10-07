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
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: categoryColor.withOpacity(0.18),
        ),
        boxShadow: [
          BoxShadow(
            color: categoryColor.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: categoryColor.withOpacity(0.12),
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
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF292747),
                  ),
                ),
              ),

              PopupMenuButton<String>(
                icon: const Icon(
                  Icons.more_vert_rounded,
                  color: Color(0xFF77747F),
                ),
                onSelected: (value) {
                  if (value == 'edit') {
                    onEdit?.call();
                  } else if (value == 'delete') {
                    onDelete?.call();
                  }
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(
                    value: 'edit',
                    child: Text('Edit'),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Text('Delete'),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Amount
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₹${spent.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF292747),
                ),
              ),

              const SizedBox(width: 5),

              Text(
                '/ ₹${budget.toStringAsFixed(0)}',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                ),
              ),

              const Spacer(),

              Text(
                '${(progress * 100).toStringAsFixed(0)}%',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: progressColor,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: categoryColor.withOpacity(0.10),
              valueColor: AlwaysStoppedAnimation<Color>(
                progressColor,
              ),
            ),
          ),

          const SizedBox(height: 10),

          // Remaining / exceeded
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

              Text(
                isOverBudget
                    ? '₹${remaining.abs().toStringAsFixed(0)} over budget'
                    : '₹${remaining.toStringAsFixed(0)} remaining',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: progressColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}