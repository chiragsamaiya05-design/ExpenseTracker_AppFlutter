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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFEFFFF5),
            Colors.white,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFBFE8D0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: const Color(0xFF26B99A).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: const Icon(
                  Icons.payments_rounded,
                  size: 20,
                  color: Color(0xFF26B99A),
                ),
              ),

              const SizedBox(width: 11),

              const Expanded(
                child: Text(
                  "Today's Spending",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF292747),
                  ),
                ),
              ),

              Text(
                '$expenseCount ${expenseCount == 1 ? 'expense' : 'expenses'}',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          Text(
            '₹${totalSpent.toStringAsFixed(0)}',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Color(0xFF292747),
            ),
          ),

          const SizedBox(height: 4),

          Text(
            'Total spent today',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),

          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            height: 42,
            child: OutlinedButton.icon(
              onPressed: onViewExpenses,
              icon: const Icon(
                Icons.receipt_long_rounded,
                size: 17,
              ),
              label: const Text(
                "View Today's Expenses",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF26B99A),
                side: const BorderSide(
                  color: Color(0xFF26B99A),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}