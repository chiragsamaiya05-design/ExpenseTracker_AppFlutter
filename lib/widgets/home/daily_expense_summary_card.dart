
import 'package:flutter/material.dart';

class DailyExpenseSummaryCard extends StatelessWidget {
  const DailyExpenseSummaryCard({
    super.key,
    required this.total,
    required this.transactions,
    required this.highest,
    required this.average,
  });

  final double total;
  final int transactions;
  final double highest;
  final double average;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Today's Expenses",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              "₹${total.toStringAsFixed(2)}",
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            Text("$transactions transactions"),

          ],
        ),
      ),
    );
  }
}