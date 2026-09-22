import 'package:flutter/material.dart';


import '../constants/add_color.dart';

class BudgetCard extends StatelessWidget {
  final String category;
  final double spent;
  final double budget;
  final IconData icon;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  const BudgetCard({
    super.key,
    required this.category,
    required this.spent,
    required this.budget,
    required this.icon,
    this.onDelete,
    this.onEdit,
  });

  double get progress {
    if (budget <= 0) return 0;

    return (spent / budget).clamp(0.0, 1.0);
  }

  double get remaining {
    return budget - spent;
  }

  bool get isOverBudget {
    return spent > budget;
  }

  Color get progressColor {
    if (isOverBudget) {
      return AppColors.danger;
    }

    if (progress >= 0.8) {
      return AppColors.warning;
    }

    return AppColors.success;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.border,
        ),
      ),

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [
          // Category + menu
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(9),

                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius:
                  BorderRadius.circular(10),
                ),

                child: Icon(
                  icon,
                  size: 20,
                  color: AppColors.primary,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Text(
                  category,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              PopupMenuButton<String>(
                icon: const Icon(
                  Icons.more_vert_rounded,
                ),

                onSelected: (value) {
                  if (value == 'edit') {
                    onEdit?.call();
                  }

                  if (value == 'delete') {
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
            crossAxisAlignment:
            CrossAxisAlignment.end,

            children: [
              Text(
                '₹${spent.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(width: 5),

              Text(
                '/ ₹${budget.toStringAsFixed(0)}',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),

              const Spacer(),

              Text(
                '${(progress * 100).toStringAsFixed(0)}%',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: progressColor,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Progress bar
          ClipRRect(
            borderRadius:
            BorderRadius.circular(10),

            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor:
              AppColors.border,
              valueColor:
              AlwaysStoppedAnimation<Color>(
                progressColor,
              ),
            ),
          ),

          const SizedBox(height: 10),

          // Remaining
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
                  color: progressColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}