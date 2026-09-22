import 'package:flutter/material.dart';

class BalanceCard extends StatelessWidget {
  final double balance;

  const BalanceCard({
    super.key,
    required this.balance,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFE8E7FF),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFD6D4FF),
        ),
      ),
      child: Row(
        mainAxisAlignment: .center,
        children: [
          Center(
            child: Column(

              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Total Balance',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF686780),
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  '₹${balance.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF292747),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}