import 'package:flutter/material.dart';

class TodaySpendingCard extends StatelessWidget {
  const TodaySpendingCard({
    super.key,
    required this.totalSpent,
    required this.expenseCount,
    required this.onViewExpenses,
  });

  final double totalSpent;
  final int expenseCount;
  final VoidCallback onViewExpenses;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    const accentColor = Color(0xFF26B99A);

    final cardBackground = isDark
        ? colorScheme.surfaceContainer
        : const Color(0xFFEFFFF5);

    final cardBorder = isDark
        ? colorScheme.outlineVariant
        : const Color(0xFFD4EDE0);

    final primaryTextColor = colorScheme.onSurface;

    final secondaryTextColor = colorScheme.onSurfaceVariant;
    return Container(
      height: 112,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            cardBackground,
            isDark
                ? colorScheme.surface
                : Colors.white,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: cardBorder
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: const Icon(
                  Icons.payments_rounded,
                  color: Color(0xFF26B99A),
                  size: 16,
                ),
              ),

              const SizedBox(width: 8),

              Expanded(
                child: Text(
                  "Today's Spending",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: primaryTextColor,
                    ),
                ),
              ),

              Text(
                '$expenseCount',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: accentColor,
                ),
              ),
            ],
          ),

          const Spacer(),

          Text(
            '₹${totalSpent.toStringAsFixed(0)}',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: primaryTextColor,
            ),
          ),

          Row(
            children: [
              Text(
                expenseCount == 1
                    ? '1 transaction'
                    : '$expenseCount transactions',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: primaryTextColor,
                ),
              ),

              const Spacer(),

              GestureDetector(
                onTap: onViewExpenses,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 2,
                  ),
                  child: const Text(
                    'View',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: accentColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}