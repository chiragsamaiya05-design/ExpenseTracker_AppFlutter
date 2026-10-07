import 'package:expense_tracker/Screens/expense/today_expense_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/budget_controller.dart';
import '../../controllers/expense_controller.dart';
import '../../widgets/common/app_bar_widget.dart';

import '../../widgets/budget/budget_section_header.dart';
import '../../widgets/budget/add_daily_budget_bottom_sheet.dart';
import '../../widgets/budget/today_budget_card.dart';
import '../../widgets/budget/today_spending_card.dart';
import '../../widgets/budget/category_budget_card.dart';
import '../../widgets/budget/add_budget_button.dart';
import '../../widgets/budget/empty_budget_state.dart';

import 'add_budget_screen.dart';
import 'edit_budget_screen.dart';

class BudgetScreen extends StatelessWidget {
  const BudgetScreen({super.key});

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Food':
        return Icons.restaurant_rounded;

      case 'Transport':
        return Icons.directions_car_rounded;

      case 'Shopping':
        return Icons.shopping_bag_rounded;

      case 'Bills':
        return Icons.receipt_long_rounded;

      case 'Entertainment':
        return Icons.movie_rounded;

      case 'Health':
        return Icons.health_and_safety_rounded;

      case 'Education':
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
      backgroundColor: const Color(0xFFF6F4FC),

      appBar: const AppBarWidget(
        title: 'Budget',
      ),

      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          16,
          12,
          16,
          24,
        ),
        children: [
          // =====================================================
          // TODAY'S BUDGET
          // =====================================================

          const BudgetSectionHeader(
            title: "Today's Budget",
            subtitle: 'Your spending limit for today',
          ),

          TodayBudgetCard(
            budget: expenseController.dailyBudget,
            remaining:
            expenseController.dailyBudgetRemaining,
            isExceeded:
            expenseController.isDailyBudgetExceeded,
            onEdit: () {
              _showDailyBudgetSheet(
                  context,
                  expenseController,);
            },
          ),

          const SizedBox(height: 22),



          const BudgetSectionHeader(
            title: "Today's Spending",
            subtitle: 'See where your money went today',
          ),

          TodaySpendingCard(
            totalSpent: expenseController.todayExpense,
            expenseCount: _getTodayExpenseCount(
              expenseController,
            ),
            onViewExpenses: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const TodayExpensesScreen(),
                ),
              );
            },
          ),

          const SizedBox(height: 22),

          const BudgetSectionHeader(
            title: 'Category Budgets',
            subtitle: 'Manage your spending limits',
          ),

          if (budgetController.budgets.isEmpty)
            EmptyBudgetState(
              onAddBudget: () {
                _openAddBudgetScreen(context);
              },
            )
          else ...[
            ...budgetController.budgets.map(
                  (budget) {
                final spent =
                expenseController.getSpentForCategory(
                  budget.category,
                );

                return CategoryBudgetCard(
                  category: budget.category,
                  spent: spent,
                  budget: budget.amount,
                  icon: _getCategoryIcon(
                    budget.category,
                  ),
                  onEdit: () {
                    _editBudget(
                      context,
                      budget,
                    );
                  },
                  onDelete: () {
                    _deleteBudget(
                      context,
                      budget,
                    );
                  },
                );
              },
            ),

            const SizedBox(height: 4),

            AddBudgetButton(
              onPressed: () {
                _openAddBudgetScreen(context);
              },
            ),
          ],
        ],
      ),
    );
  }



  int _getTodayExpenseCount(
      ExpenseController controller,
      ) {
    final now = DateTime.now();

    return controller.expenses.where(
          (expense) {
        return expense.date.year == now.year &&
            expense.date.month == now.month &&
            expense.date.day == now.day;
      },
    ).length;
  }



  Future<void> _openAddBudgetScreen(
      BuildContext context,
      ) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AddBudgetScreen(),
      ),
    );

    if (!context.mounted) return;

    await context
        .read<BudgetController>()
        .loadBudgetData();
  }



  Future<void> _editBudget(
      BuildContext context,
      dynamic budget,
      ) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditBudgetScreen(
          budget: budget,
        ),
      ),
    );

    if (!context.mounted) return;

    await context
        .read<BudgetController>()
        .loadBudgetData();
  }


  Future<void> _deleteBudget(
      BuildContext context,
      dynamic budget,
      ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Delete Budget?',
          ),
          content: Text(
            'Are you sure you want to delete '
                'the ${budget.category} budget?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  false,
                );
              },
              child: const Text('Cancel'),
            ),

            FilledButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  true,
                );
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    if (!context.mounted) return;

    await context
        .read<BudgetController>()
        .loadBudgetData();
  }
  Future<void> _showDailyBudgetSheet(
      BuildContext context,
      ExpenseController controller,
      ) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (context) {
        return AddDailyBudgetBottomSheet(
          currentBudget: controller.dailyBudget,
          isLoading: controller.isDailyBudgetLoading,
          onSave: (amount) async {
            await controller.saveDailyBudget(amount);
          },
        );
      },
    );
  }
}