import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/add_expense_result.dart';
import '../../models/expense_model.dart';

import '../../widgets/budget/add_daily_budget_bottom_sheet.dart';
import '../../widgets/home/daily_budget_card.dart';
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

import '../../auth/controllers/auth_controller.dart';
import '../../auth/screens/login_screen.dart';

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
          isSearching: controller.isSearching,

          onSearchChanged: (value) {
            controller.setSearchText(value);
          },

          onSearch: () {
            controller.startSearch();
          },

          onCloseSearch: () {
            controller.closeSearch();
          },

          // Temporary logout button
          onLogout: () async {
            await context.read<AuthController>().logout();

            if (!context.mounted) return;

            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (_) => const LoginScreen(),
              ),
                  (route) => false,
            );
          },
        ),

        // =====================================================
        // BODY
        // =====================================================

        body: Consumer<ExpenseController>(
          builder: (context, controller, child) {
            final recentExpenses =
            controller.displayExpenses.take(3).toList();

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  16,
                  12,
                  16,
                  0,
                ),
              
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
              
              
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: BalanceCard(
                            balance: controller.totalBalance,
                          ),
                        ),
              
                        const SizedBox(width: 12),
              
                        Expanded(
                          child: DailyBudgetCard(
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
                        ),
                      ],
                    ),
              
                    const SizedBox(height: 14),
              
                    Row(
                      children: [
                        Expanded(
                          child: IncomeExpenseCard(
                            title: 'Income',
                            amount: controller.monthlyIncome,
                            color: const Color(0xFFD9F7E5),
              
                            onTap: () async {
                              await showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                builder: (context) {
                                  return AddIncomeScreen(
                                    controller: controller,
                                  );
                                },
                              );
                            },
                          ),
                        ),
              
                        const SizedBox(width: 16),
              
                        Expanded(
                          child: IncomeExpenseCard(
                            title: 'Expense',
                            amount: controller.totalExpense,
                            color: const Color(0xFFFFE0DE),
              
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                  const AddExpenseScreen(),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10,),
              
                    QuickAddCategorySection(
                      categories: controller.quickAddCategories,
                      onCategoryTap: (category) {
                        showQuickAddSheet(
                          context,
                          category,
                        );
                      },
                    ),
              
                    const SizedBox(height: 16),
              
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
              
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
              
                          decoration: BoxDecoration(
                            color: const Color(0xFFE7E9FF),
                            borderRadius:
                            BorderRadius.circular(10),
                          ),
              
                          child: const Icon(
                            Icons.receipt_long_rounded,
                            color: Color(0xFF5B5FC7),
                            size: 20,
                          ),
                        ),
              
              
                        const SizedBox(width: 10),
              
                        const Expanded(
                          child: Text(
                            'Recent Transactions',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
              
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                const AllExpensesScreen(),
                              ),
                            );
                          },
              
                          child: const Text(
                            'View All',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
              
                    const SizedBox(height: 8),
              
                    if (recentExpenses.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Center(
                          child: Text(
                            'No recent transactions',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      )
                    else
                      Column(
                        children: recentExpenses.map((expense) {
                          return ExpenseListItem(
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
                          );
                        }).toList(),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
        floatingActionButton:
        FloatingActionButton(
          backgroundColor:
          const Color(0xFF6750A4),

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