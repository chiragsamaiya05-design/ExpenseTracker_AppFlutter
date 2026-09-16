import 'package:flutter/material.dart';

import '../controllers/expense_controller.dart';
import '../widgets/expense_list_item.dart';
import 'package:expense_tracker/widgets/expense_filter_bottom_sheet.dart';
import '../utils/confirmation_dailog.dart';
import 'edit_expense_screen.dart';
import '../database/expenses_DataBase.dart';
import '../repositories/expense_repository.dart';



class AllExpensesScreen extends StatefulWidget {
  const AllExpensesScreen({super.key});

  @override
  State<AllExpensesScreen> createState() => _AllExpensesScreenState();
}

class _AllExpensesScreenState extends State<AllExpensesScreen> {
  final ExpenseController controller = ExpenseController(
    repository: ExpenseRepository(
      database: ExpensesDatabase(),
    ),
  );



  Future<void> loadExpenses() async {
    await controller.loadExpenses();

    if (mounted) {
      setState(() {});
    }
  }
  void showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return ExpenseFilterBottomSheet(
          selectedCategory: controller.selectedCategory,
          selectedSort: controller.selectedSort,
          selectedDate: controller.selectedDate,

          onApply: (category, sort, date) {
            setState(() {
              controller.selectedCategory = category;
              controller.selectedSort = sort;
              controller.selectedDate = date;
            });
          },

          onClear: () {
            setState(() {
              controller.selectedCategory = "All";
              controller.selectedSort = "Newest";
              controller.selectedDate = "All";
            });
          },
        );
      },
    );
  }


  @override
  void initState() {
    super.initState();
    loadExpenses();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("All Expenses"),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              showFilterBottomSheet();
            },
          ),
        ],
      ),

      body: ListView.builder(
        itemCount: controller.allFilteredExpenses.length,
        itemBuilder: (context, index) {
          final expense = controller.allFilteredExpenses[index];

          return ExpenseListItem(
            expense: expense,

            onEdit: () async {
              final updatedExpense = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditExpenseScreen(
                    expense: expense,
                  ),
                ),
              );

              if (updatedExpense != null) {
                await controller.updateExpense(updatedExpense);
                if (mounted) {
                  setState(() {});
                }
              }
            },

            onDelete: () async {
              final confirmed = await showConfirmationDialog(
                context,
                title: "Delete Expense",
                message: "Are you sure you want to delete this expense?",
              );

              if (confirmed) {
                await controller.deleteExpense(expense.id!);
                if (mounted) {
                  setState(() {});
                }
              }
            },
          );
        },
      ),
    );
  }
}