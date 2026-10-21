import 'package:flutter/material.dart';
import '../../models/monthly_summary_model.dart';

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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final bool hasRemaining = summary.remaining > 0;
    final bool hasExtraExpense = summary.extraExpense > 0;

    const successColor = Color(0xFF3F8F5B);
    const dangerColor = Color(0xFFC65F73);
    const primaryColor = Color(0xFF6557D9);

    final Color accentColor = hasRemaining
        ? successColor
        : hasExtraExpense
        ? dangerColor
        : colorScheme.onSurfaceVariant;

    final Color cardColor = colorScheme.surface;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: cardColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: colorScheme.outlineVariant,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 4,
                  height: 22,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: Text(
                    '$monthName ${summary.year}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),

                if (hasRemaining || hasExtraExpense)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: accentColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      hasRemaining ? 'Surplus' : 'Over budget',
                      style: TextStyle(
                        color: accentColor,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 16),

            _row(
              context,
              'Income',
              summary.income,
            ),

            _row(
              context,
              'Total Expense',
              summary.totalExpense,
            ),

            _row(
              context,
              'Remaining',
              summary.remaining,
              color: hasRemaining ? successColor : null,
            ),

            _row(
              context,
              'Extra Expense',
              summary.extraExpense,
              color: hasExtraExpense ? dangerColor : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(
      BuildContext context,
      String title,
      double amount, {
        Color? color,
      }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: 12,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),

          const SizedBox(width: 12),

          Text(
            '₹${amount.toStringAsFixed(2)}',
            style: theme.textTheme.bodySmall?.copyWith(
              fontSize: 12,
              fontWeight: color != null
                  ? FontWeight.w600
                  : FontWeight.normal,
              color: color ?? colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}