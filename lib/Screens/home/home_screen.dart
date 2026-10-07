import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/add_expense_result.dart';
import '../../models/expense_model.dart';

import '../../widgets/budget/add_daily_budget_bottom_sheet.dart';
import '../../widgets/home/daily_budget_card.dart';
import '../../widgets/home/recent_transaction_item.dart';
import '../expense/add_expense_screen.dart';
import '../expense/edit_expense_screen.dart';
import '../expense/all_expenses_screen.dart';
import '../income/add_income_screen.dart';

import '../../controllers/expense_controller.dart';
import '../../widgets/quick_add/quick_add_category_section.dart';
import '../../widgets/quick_add/show_quick_add_sheet.dart';

import 'package:expense_tracker/widgets/home/balance_card.dart';
import 'package:expense_tracker/widgets/home/income_expense_card.dart';
import 'package:expense_tracker/widgets/expense/expense_list_item.dart';
import 'package:expense_tracker/widgets/home/home_app_bar.dart';

import 'package:expense_tracker/utils/confirmation_dailog.dart';


import '../../widgets/monthly_settlement_listener.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ExpenseController>();

    final recentExpenses =
    controller.displayExpenses.take(3).toList();

    return MonthlySettlementListener(
      child: Scaffold(
        appBar: HomeAppBar(
          onSearchTap: () {
            // Search action
          },
          onNotificationTap: () {
            // Notification action
          },
        ),


        // BODY
        body: Consumer<ExpenseController>(
          builder: (context, controller, child) {
            final recentExpenses =
            controller.displayExpenses.take(3).toList();

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                16,
                12,
                16,
                100,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BalanceCard(
                    balance: controller.totalBalance,
                    income: controller.monthlyIncome,
                    expense: controller.totalExpense,

                    onIncomeTap: () async {
                      await showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (_) {
                          return AddIncomeScreen(
                            controller: controller,
                          );
                        },
                      );
                    },

                    onExpenseTap: () async {
                      final AddExpenseResult? result =
                      await Navigator.push<AddExpenseResult>(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AddExpenseScreen(),
                        ),
                      );

                      if (result != null) {
                        await controller.addExpense(result.expense);
                      }
                    },
                  ),
                  const SizedBox(height: 10),

                  DailyBudgetCard(
                    dailyBudget: controller.dailyBudget,
                    remaining: controller.dailyBudgetRemaining,
                    isExceeded: controller.isDailyBudgetExceeded,
                    onEdit: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(24),
                          ),
                        ),
                        builder: (_) {
                          return AddDailyBudgetBottomSheet(
                            currentBudget: controller.dailyBudget,
                            isLoading: controller.isDailyBudgetLoading,
                            onSave: (amount) async {
                              await controller.saveDailyBudget(amount);
                            },
                          );
                        },
                      );
                    },
                  ),

                  const SizedBox(height: 14),

                  QuickAddCategorySection(
                    categories: controller.quickAddCategories,
                    onCategoryTap: (category) {
                      showQuickAddSheet(
                        context,
                        category,
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE7E9FF),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.receipt_long_rounded,
                          color: Color(0xFF5B5FC7),
                          size: 20,
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: Text(
                          'Recent Transactions',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),

                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AllExpensesScreen(),
                            ),
                          );
                        },
                        child: const Text('View all'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  if (recentExpenses.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 28,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.outlineVariant,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.receipt_long_outlined,
                            size: 32,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'No recent transactions',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            'Your latest expenses will appear here.',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.outlineVariant,
                        ),
                      ),
                      child: Column(
                        children: recentExpenses.asMap().entries.map((entry) {
                          final index = entry.key;
                          final expense = entry.value;

                          return Column(
                            children: [
                              RecentTransactionItem(
                                expense: expense,
                                onEdit: () async {
                                  final Expense? updatedExpense =
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => EditExpenseScreen(
                                        expense: expense,
                                      ),
                                    ),
                                  );

                                  if (updatedExpense != null) {
                                    await controller.updateExpense(
                                      updatedExpense,
                                    );
                                  }
                                },
                                onDelete: () async {
                                  final confirmed =
                                  await showConfirmationDialog(
                                    context,
                                    title: 'Delete Expense',
                                    message:
                                    'Are you sure you want to delete this expense?',
                                  );

                                  if (confirmed) {
                                    await controller.deleteExpense(
                                      expense.id!,
                                    );
                                  }
                                },
                              ),

                              if (index != recentExpenses.length - 1)
                                Divider(
                                  height: 1,
                                  indent: 68,
                                  endIndent: 16,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .outlineVariant,
                                ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
        floatingActionButton:
        FloatingActionButton(
          backgroundColor: const Color(0xFF6750A4),
          foregroundColor: Colors.white,
          shape: const CircleBorder(),
          elevation: 6,

          onPressed: () async {
            final AddExpenseResult? result =
            await Navigator.push<AddExpenseResult>(
              context,
              MaterialPageRoute<AddExpenseResult>(
                builder: (context) => const AddExpenseScreen(),
              ),
            );

            if (result != null) {
              await context
                  .read<ExpenseController>()
                  .addExpense(result.expense);
            }
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}