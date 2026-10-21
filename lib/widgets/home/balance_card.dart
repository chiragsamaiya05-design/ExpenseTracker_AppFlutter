import 'package:flutter/material.dart';

import 'finance_item.dart';

class BalanceCard extends StatelessWidget {
  final double balance;
  final double income;
  final double expense;

  final VoidCallback? onIncomeTap;
  final VoidCallback? onExpenseTap;

  const BalanceCard({
    super.key,
    required this.balance,
    required this.income,
    required this.expense,
    this.onIncomeTap,
    this.onExpenseTap,
  });

  String _formatAmount(double amount) {
    final formatted = amount
        .toStringAsFixed(2)
        .replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
          (match) => ',',
    );

    return '₹$formatted';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final gradientColors = isDark
        ? const [
      Color(0xFF292644),
      Color(0xFF393354),
    ]
        : const [
      Color(0xFFA8A4D8),
      Color(0xFFC1BEE8),
    ];

    final primaryTextColor =
    isDark ? const Color(0xFFF4F1FF) : const Color(0xFF3E3A68);

    final secondaryTextColor =
    isDark ? const Color(0xFFD0CBE8) : const Color(0xFF514D7A);

    final dividerColor = isDark
        ? Colors.white.withValues(alpha: 0.14)
        : const Color(0xFF7F7BAF).withValues(alpha: 0.22);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),

        // Light lavender gradient
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
          
        ),

        boxShadow: [
          BoxShadow(
            color: isDark
            ? Colors.black.withValues(alpha: 0.25)
                : const Color(0xFF7772AD).withValues(alpha: 0.20),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),

      clipBehavior: Clip.antiAlias,

      child: Stack(
        children: [
          // Top-right decorative circle
          Positioned(
            right: -45,
            top: -55,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.10),
              ),
            ),
          ),

          // Bottom-left decorative circle
          Positioned(
            left: -60,
            bottom: -70,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.05),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(
              20,
              18,
              20,
              16,
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ---------------------------------------------------------
                // HEADER
                // ---------------------------------------------------------

                Row(
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(
                          alpha: isDark ? 0.10 : 0.32,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.account_balance_wallet_rounded,
                        size: 19,
                        color: secondaryTextColor,
                      ),
                    ),

                    const SizedBox(width: 10),

                    Text(
                      'Total Balance',
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: secondaryTextColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // ---------------------------------------------------------
                // BALANCE
                // ---------------------------------------------------------

                Text(
                  _formatAmount(balance),
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: primaryTextColor,
                    fontWeight: FontWeight.w800,
                    fontSize: 30,
                    letterSpacing: -0.8,
                  ),
                ),

                const SizedBox(height: 16),

                // ---------------------------------------------------------
                // DIVIDER
                // ---------------------------------------------------------

                Container(
                  height: 1,
                  color: dividerColor,
                ),

                const SizedBox(height: 14),

                // ---------------------------------------------------------
                // INCOME + EXPENSE
                // ---------------------------------------------------------

                Row(
                  children: [
                    Expanded(
                      child: FinanceItem(
                        icon: Icons.arrow_downward_rounded,
                        label: 'Income',
                        amount: income,
                        iconColor: const Color(0xFF32C978),
                        onTap: onIncomeTap,
                      ),
                    ),

                    Container(
                      width: 1,
                      height: 46,
                        color: dividerColor,
                    ),

                    Expanded(
                      child: FinanceItem(
                        icon: Icons.arrow_upward_rounded,
                        label: 'Expenses',
                        amount: expense,
                        iconColor: const Color(0xFFF17B86),
                        onTap: onExpenseTap,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

