import 'package:flutter/material.dart';

class SummaryCard extends StatelessWidget {
  final String monthYear;
  final double income;
  final double expense;
  final double balance;

  const SummaryCard({
    super.key,
    required this.monthYear,
    required this.income,
    required this.expense,
    required this.balance,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text(monthYear),
          ),
          const SizedBox(height: 10),

          ListTile(
            title: const Text("Income"),
            trailing: Text(
              income.toStringAsFixed(2),
            ),
          ),

          const SizedBox(height: 5),

          ListTile(
            title: const Text("Expense"),
            trailing: Text(
              expense.toStringAsFixed(2),
            ),
          ),

          const SizedBox(height: 5),

          ListTile(
            title: const Text("Balance"),
            trailing: Text(
              balance.toStringAsFixed(2),
            ),
          ),
        ],
      ),
    );
  }
}