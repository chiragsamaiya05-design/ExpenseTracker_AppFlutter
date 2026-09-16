import 'package:flutter/material.dart';

class IncomeExpenseCard extends StatelessWidget {
  final String title;
  final double amount;
  final VoidCallback? onTap;

  const IncomeExpenseCard({
    super.key,
    required this.title,
    required this.amount,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(title),

                Text(
                  amount.toStringAsFixed(2),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}