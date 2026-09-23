import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/add_color.dart';
import '../controllers/budget_controller.dart';
import '../controllers/expense_controller.dart';
import '../widgets/app_bar_widget.dart';
import 'add_budget_screen.dart';
import '../models/budget_model.dart';
import 'edit_budget_screen.dart';

class BudgetScreen extends StatelessWidget {
  const BudgetScreen({super.key});

  IconData getCategoryIcon(String category) {
    switch (category) {
      case "Food":
        return Icons.restaurant_rounded;

      case "Transport":
        return Icons.directions_car_rounded;

      case "Shopping":
        return Icons.shopping_bag_rounded;

      case "Bills":
        return Icons.receipt_long_rounded;

      case "Entertainment":
        return Icons.movie_rounded;

      case "Health":
        return Icons.health_and_safety_rounded;

      case "Education":
        return Icons.school_rounded;

      default:
        return Icons.category_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final budgetController =
    context.watch<BudgetController>();

    final expenseController =
    context.watch<ExpenseController>();

    return Scaffold(
      appBar: const AppBarWidget(
        title: 'Budget',
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),

        children: [
          const Text(
            "Category Budgets",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 12),

          if (budgetController.budgets.isEmpty)
            _emptyBudgetState()
          else
            ...budgetController.budgets.map(
                  (budget) {
                // Calculate spending for this category
                final spent =
                expenseController.getSpentForCategory(
                  budget.category,
                );

                return _budgetCard(
                  context,
                  budgetData: budget,
                  spend: spent,
                );
              },
            ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF6750A4),
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        elevation: 6,

        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddBudgetScreen(),
            ),
          );

          if (!context.mounted) return;

          await context
              .read<BudgetController>()
              .loadBudgetData();
        },

        child: const Icon(Icons.add),
      ),
    );
  }
  Widget _budgetCard(
      BuildContext context, {
        required Budget budgetData,
        required double spend,
      }) {
    final double budget = budgetData.amount;
    final double spent = spend;

    final double progress = budget <= 0
        ? 0.0
        : (spent / budget).clamp(0.0, 1.0);

    final double remaining = budget - spent;

    final bool isOverBudget = spent > budget;

    final Color progressColor = isOverBudget
        ? AppColors.danger
        : progress >= 0.8
        ? AppColors.warning
        : AppColors.success;

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  getCategoryIcon(budgetData.category),
                  color: AppColors.primary,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Text(
                  budgetData.category,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              // Edit Budget
              IconButton(
                icon: const Icon(
                  Icons.edit_rounded,
                  size: 20,
                ),
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditBudgetScreen(
                        budget: budgetData,
                      ),
                    ),
                  );

                  if (!context.mounted) return;

                  await context
                      .read<BudgetController>()
                      .loadBudgetData();
                },
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Amount
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "₹${spent.toStringAsFixed(0)}",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(width: 5),

              Text(
                "/ ₹${budget.toStringAsFixed(0)}",
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),

              const Spacer(),

              Text(
                "${(progress * 100).toStringAsFixed(0)}%",
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
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: AppColors.border,
              valueColor: AlwaysStoppedAnimation<Color>(
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
                    ? "₹${remaining.abs().toStringAsFixed(0)} over budget"
                    : "₹${remaining.toStringAsFixed(0)} remaining",
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

  Widget _emptyBudgetState() {
    return Container(
      padding: const EdgeInsets.all(30),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.border,
        ),
      ),

      child: Column(
        children: [
          const Icon(
            Icons.account_balance_wallet_outlined,
            size: 48,
            color: AppColors.textSecondary,
          ),

          const SizedBox(height: 12),

          const Text(
            "No budgets yet",
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 6),

          const Text(
            "Create a budget to start tracking your spending.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}