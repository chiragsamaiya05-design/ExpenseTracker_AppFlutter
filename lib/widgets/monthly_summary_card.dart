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
    final bool hasRemaining = summary.remaining > 0;
    final bool hasExtraExpense = summary.extraExpense > 0;

    final Color cardColor = hasRemaining
        ? const Color(0xFFE3F5E9)
        : hasExtraExpense
        ? const Color(0xFFFFE5E5)
        : Colors.white;

    final Color accentColor = hasRemaining
        ? const Color(0xFF3F8F5B)
        : hasExtraExpense
        ? const Color(0xFFC65F73)
        : Colors.grey;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$monthName ${summary.year}',
              style: const TextStyle(
                fontSize: 15,
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
              color: hasRemaining
                  ? accentColor
                  : null,
            ),

            _row(
              'Extra Expense',
              summary.extraExpense,
              color: hasExtraExpense
                  ? accentColor
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(String title, double amount,{Color? color}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
              title,
              style: const TextStyle(
                fontSize: 11,),
          ),
          Text(
            '₹${amount.toStringAsFixed(2)}',
            style:  TextStyle(
              fontSize: 11,
              fontWeight: color != null
              ?FontWeight.w600 :.normal,
              color: color,
            ),
          ),

        ],
      ),
    );
  }
}