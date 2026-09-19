import 'package:flutter/material.dart';
import '../models/monthly_summary_model.dart';

class MonthlySummaryCard extends StatelessWidget {
  final MonthlySummary summary;

  const MonthlySummaryCard({
    super.key,
    required this.summary,
  });

  String get monthName {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return months[summary.month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$monthName ${summary.year}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            _row(
              'Income',
              summary.income,
            ),

            _row(
              'Total Expense',
              summary.totalExpense,
            ),

            _row(
              'Remaining',
              summary.remaining,
            ),

            _row(
              'Extra Expense',
              summary.extraExpense,
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(String title, double amount) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Text(
            '₹${amount.toStringAsFixed(2)}',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}