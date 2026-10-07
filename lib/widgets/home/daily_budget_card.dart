import 'package:flutter/material.dart';

class DailyBudgetCard extends StatelessWidget {
  const DailyBudgetCard({
    super.key,
    required this.dailyBudget,
    required this.remaining,
    required this.isExceeded,
    required this.onEdit,
  });

  final double dailyBudget;
  final double remaining;
  final bool isExceeded;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasBudget = dailyBudget > 0;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onEdit,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          height: 136,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 13,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFE8E7FF),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: const Color(0xFFD6D4FF),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Header
              const Text(
                'Daily Budget',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF292747),
                ),
              ),

              if (hasBudget) ...[
                const SizedBox(height: 14),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Budget
                    _BudgetValue(
                      amount: dailyBudget,
                      label: 'Budget',
                    ),

                    // Remaining
                    _BudgetValue(
                      amount: remaining.abs(),
                      label: isExceeded
                          ? 'Exceeded'
                          : 'Remaining',
                      isExceeded: isExceeded,
                    ),
                  ],
                ),
              ] else ...[
                const SizedBox(height: 14),

                Text(
                  'No daily budget set',
                  style: TextStyle(
                    fontSize: 11,
                    color: theme.colorScheme.onSurface.withOpacity(0.5),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _BudgetValue extends StatelessWidget {
  const _BudgetValue({
    required this.amount,
    required this.label,
    this.isExceeded = false,
  });

  final double amount;
  final String label;
  final bool isExceeded;

  @override
  Widget build(BuildContext context) {
    final amountColor = isExceeded
        ? Colors.redAccent
        : const Color(0xFF292747);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '₹${amount.toStringAsFixed(0)}',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: amountColor,
            height: 1.0,
          ),
        ),

        const SizedBox(height: 4),

        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: const Color(0xFF292747).withOpacity(0.5),
            height: 1.0,
          ),
        ),
      ],
    );
  }
}