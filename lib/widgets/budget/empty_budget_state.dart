import 'package:flutter/material.dart';

class EmptyBudgetState extends StatelessWidget {
  const EmptyBudgetState({
    super.key,
    required this.onAddBudget,
  });

  final VoidCallback onAddBudget;

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    const primaryColor = Color(0xFF6557D9);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 24,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: colorScheme.outlineVariant,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark
                  ? primaryColor.withValues(alpha: 0.18)
                  : const Color(0xFFF0EDFF),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.account_balance_wallet_outlined,
              size: 28,
              color: Color(0xFF6557D9),
            ),
          ),

          const SizedBox(height: 12),

          Text(
            'No Category Budgets',
              style: theme.textTheme.titleMedium?.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
              ),
          ),

          const SizedBox(height: 5),

          Text(
            'Create budgets for categories like Food,\n'
                'Transport, Shopping and more.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
            fontSize: 12,
            height: 1.4,
            color: colorScheme.onSurfaceVariant,
            ),
            ),


          const SizedBox(height: 16),

          OutlinedButton.icon(
            onPressed: onAddBudget,
            icon: const Icon(
              Icons.add_rounded,
              size: 18,
            ),
            label: const Text(
              'Create Budget',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: colorScheme.primary,
              side: BorderSide(
                color: colorScheme.primary,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}