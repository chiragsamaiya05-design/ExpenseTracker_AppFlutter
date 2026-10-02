import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/expense_controller.dart';
import '../widgets/expense_list_item.dart';
import '../widgets/app_bar_widget.dart';

class TodayExpensesScreen extends StatelessWidget {
  const TodayExpensesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ExpenseController>();

    final now = DateTime.now();

    final todayExpenses = controller.expenses.where(
          (expense) =>
      expense.date.year == now.year &&
          expense.date.month == now.month &&
          expense.date.day == now.day,
    ).toList();

    return Scaffold(
      appBar: const AppBarWidget(
        title: "Today's Transactions",
      ),

      body: todayExpenses.isEmpty
          ? const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 48,
              color: Colors.grey,
            ),
            SizedBox(height: 12),
            Text(
              "No transactions today",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 4),
            Text(
              "Your transactions will appear here.",
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: todayExpenses.length,
        itemBuilder: (context, index) {
          final expense = todayExpenses[index];

          return ExpenseListItem(
            expense: expense,

            onEdit: () {
              // Add your existing edit logic here
            },

            onDelete: () async {
              if (expense.id != null) {
                await controller.deleteExpense(
                  expense.id!,
                );
              }
            },
          );
        },
      ),
    );
  }
}