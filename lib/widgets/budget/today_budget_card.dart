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
    final hasBudget = budget > 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF6557D9),
            Color(0xFF8B7CF6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6557D9).withOpacity(0.20),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.16),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: const Icon(
                  Icons.today_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),

              const SizedBox(width: 11),

              const Expanded(
                child: Text(
                  "Today's Budget",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              IconButton(
                onPressed: onEdit,
                icon: Icon(
                  hasBudget
                      ? Icons.edit_rounded
                      : Icons.add_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                tooltip: hasBudget
                    ? 'Edit Budget'
                    : 'Set Budget',
              ),
            ],
          ),

          const SizedBox(height: 20),

          if (hasBudget) ...[
            Text(
              '₹${budget.toStringAsFixed(0)}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              isExceeded
                  ? '₹${remaining.abs().toStringAsFixed(0)} over budget'
                  : '₹${remaining.toStringAsFixed(0)} remaining',
              style: TextStyle(
                color: Colors.white.withOpacity(0.85),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ] else ...[
            Text(
              'No budget set',
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              'Set a spending limit for today',
              style: TextStyle(
                color: Colors.white.withOpacity(0.75),
                fontSize: 13,
              ),
            ),
          ],
        ],
      ),
    );
  }
}