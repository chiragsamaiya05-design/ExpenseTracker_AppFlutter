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
      height: 112,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFEFFFF5),
            Colors.white,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFD4EDE0),
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
                  color: const Color(0xFF26B99A)
                      .withOpacity(0.12),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: const Icon(
                  Icons.payments_rounded,
                  color: Color(0xFF26B99A),
                  size: 16,
                ),
              ),

              const SizedBox(width: 8),

              const Expanded(
                child: Text(
                  "Today's Spending",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF292747),
                  ),
                ),
              ),

              Text(
                '$expenseCount',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF26B99A),
                ),
              ),
            ],
          ),

          const Spacer(),

          Text(
            '₹${totalSpent.toStringAsFixed(0)}',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFF292747),
            ),
          ),

          Row(
            children: [
              Text(
                expenseCount == 1
                    ? '1 transaction'
                    : '$expenseCount transactions',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey.shade600,
                ),
              ),

              const Spacer(),

              GestureDetector(
                onTap: onViewExpenses,
                child: const Text(
                  'View',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF26B99A),
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