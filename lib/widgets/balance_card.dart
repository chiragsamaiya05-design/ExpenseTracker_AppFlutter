import 'package:flutter/material.dart';

class BalanceCard extends StatelessWidget {
  final double balance;

  const BalanceCard({
    super.key,
    required this.balance,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
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
        mainAxisAlignment: .start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Header
          const Text(
            'Total Balance',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF292747),
            ),
          ),

          const SizedBox(height: 14),

          Text(
            '₹${balance.toStringAsFixed(0)}',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF292747),
            ),
          ),

          const SizedBox(height: 3),

          Text(
            'Available balance',
            style: TextStyle(
              fontSize: 11,
              color: theme.colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }
}