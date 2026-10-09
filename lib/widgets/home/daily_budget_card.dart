import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DailyBudgetCard extends StatelessWidget {
  final double dailyBudget;
  final double remaining;
  final bool isExceeded;
  final VoidCallback? onEdit;

  const DailyBudgetCard({
    super.key,
    required this.dailyBudget,
    required this.remaining,
    required this.isExceeded,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final spent = dailyBudget - remaining;

    final statusColor = isExceeded
        ? colorScheme.error
        : colorScheme.primary;

    // Theme-aware card styling.
    final cardColor = colorScheme.surface;

    final borderColor = colorScheme.outlineVariant.withValues(
      alpha: isDark ? 0.65 : 0.8,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: borderColor,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: isDark?0.12:0.035,
            ),
            blurRadius: 12,
            offset:  const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.track_changes_rounded,
                  size: 20,
                  color: colorScheme.primary,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Text(
                  'Daily Budget',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),

              IconButton(
                onPressed: onEdit,
                tooltip: 'Edit budget',
                visualDensity: VisualDensity.compact,
                icon: Icon(
                  Icons.edit_rounded,
                  size: 19,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          if (dailyBudget <= 0) ...[
            Text(
              'No daily budget set',
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Set a budget to track your spending today.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ] else ...[
            Text(
              '₹${remaining.toStringAsFixed(0)}',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: statusColor,
              ),
            ),

            const SizedBox(height: 2),

            Text(
              isExceeded
                  ? 'Over budget today'
                  : 'Remaining today',
              style: theme.textTheme.bodySmall?.copyWith(
                color: isExceeded
                    ? colorScheme.error
                    : colorScheme.onSurfaceVariant,
                fontWeight: isExceeded
                    ? FontWeight.w600
                    : FontWeight.normal,
              ),
            ),

            const SizedBox(height: 14),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    '₹${spent.clamp(0, double.infinity).toStringAsFixed(0)} spent',
                    style: theme.textTheme.labelMedium?.copyWith(
                    color: isExceeded
                        ? colorScheme.error
                        : colorScheme.onSurfaceVariant,
                    fontWeight: isExceeded
                        ? FontWeight.w600
                        : FontWeight.normal,
                    ),
                  ),
                ),

                const SizedBox(width: 8,),

                Flexible(
                  child: Text(
                    '₹${dailyBudget.toStringAsFixed(0)} budget',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}