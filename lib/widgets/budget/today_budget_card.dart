import 'package:flutter/material.dart';

class TodayBudgetCard extends StatelessWidget {
  const TodayBudgetCard({
    super.key,
    required this.budget,
    required this.remaining,
    required this.isExceeded,
    required this.onEdit,
  });

  final double budget;
  final double remaining;
  final bool isExceeded;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final hasBudget = budget > 0;

    // Use a deeper gradient in dark mode.
    final gradientColors = isDark
        ? const [
      Color(0xFF302956),
      Color(0xFF453B75),
    ]
        : const [
      Color(0xFF6557D9),
      Color(0xFF8174EC),
    ];

    final secondaryTextColor = Colors.white.withValues(
      alpha: isDark ? 0.82 : 0.78,
    );

    return Container(
      width: double.infinity,
      height: 112,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6557D9).withValues(
              alpha: isDark ? 0.10 : 0.16,
            ),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header.
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(
                    alpha: isDark ? 0.10 : 0.16,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.today_rounded,
                  color: Colors.white,
                  size: 16,
                ),
              ),

              const SizedBox(width: 8),

              const Expanded(
                child: Text(
                  "Today's Budget",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),

              SizedBox(
                width: 30,
                height: 30,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  tooltip: hasBudget ? 'Edit budget' : 'Add budget',
                  onPressed: onEdit,
                  icon: Icon(
                    hasBudget
                        ? Icons.edit_rounded
                        : Icons.add_rounded,
                    size: 15,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),

          const Spacer(),

          // Budget amount and remaining balance.
          if (hasBudget) ...[
            Text(
              '₹${budget.toStringAsFixed(0)}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 2),

            Text(
              isExceeded
                  ? '₹${remaining.abs().toStringAsFixed(0)} over budget'
                  : '₹${remaining.toStringAsFixed(0)} remaining',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: isExceeded
                    ? const Color(0xFFFFB8B8)
                    : secondaryTextColor,
              ),
            ),
          ] else ...[
            const Text(
              'No budget set',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 2),

            Text(
              'Set a limit for today',
              style: TextStyle(
                fontSize: 10,
                color: secondaryTextColor,
              ),
            ),
          ],
        ],
      ),
    );
  }
}