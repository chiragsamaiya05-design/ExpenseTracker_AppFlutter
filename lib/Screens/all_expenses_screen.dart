import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/expense_controller.dart';
import '../widgets/expense_list_item.dart';
import '../widgets/expense_filter_bottom_sheet.dart';
import '../utils/confirmation_dailog.dart';
import 'edit_expense_screen.dart';


class AllExpensesScreen extends StatelessWidget {
  const AllExpensesScreen({super.key});

  void showFilterBottomSheet(BuildContext context) {
    final controller = context.read<ExpenseController>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (bottomSheetContext) {
        return ExpenseFilterBottomSheet(
          selectedCategory: controller.selectedCategory,
          selectedSort: controller.selectedSort,
          selectedDate: controller.selectedDate,

          onApply: (category, sort, date) {
            controller.setFilters(
              category,
              sort,
              date,
            );

            Navigator.pop(bottomSheetContext);
          },

          onClear: () {
            controller.setFilters(
              "All",
              "Newest",
              "All",
            );

            Navigator.pop(bottomSheetContext);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ExpenseController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("All Expenses"),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              showFilterBottomSheet(context);
            },
          ),
        ],
      ),
      body: _buildBody(context, controller),
    );
  }

  Widget _buildBody(
      BuildContext context,
      ExpenseController controller,
      ) {
    if (controller.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (controller.errorMessage != null) {
      return Center(
        child: Text(
          controller.errorMessage!,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
      );
    }

    if (controller.allFilteredExpenses.isEmpty) {
      return const Center(
        child: Text(
          "No expenses found",
          style: TextStyle(
            fontSize: 18,
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: controller.allFilteredExpenses.length,
      itemBuilder: (context, index) {
        final expense =
        controller.allFilteredExpenses[index];

        return ExpenseListItem(
          expense: expense,

          onEdit: () async {
            final updatedExpense = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return EditExpenseScreen(
                    expense: expense,
                  );
                },
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
              title: "Delete Expense",
              message:
              "Are you sure you want to delete this expense?",
            );

            if (confirmed) {
              await controller.deleteExpense(
                expense.id!,
              );
            }
          },
        );
      },
    );
  }
}