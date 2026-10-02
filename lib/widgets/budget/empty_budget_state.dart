import 'package:flutter/material.dart';

class EmptyBudgetState extends StatelessWidget {
  const EmptyBudgetState({
    super.key,
    required this.onAddBudget,
  });

  final VoidCallback onAddBudget;

  @override
  Widget build(BuildContext context) {
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
          color: const Color(0xFFE5E2EF),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF0EDFF),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.account_balance_wallet_outlined,
              size: 28,
              color: Color(0xFF6557D9),
            ),
          ),

          const SizedBox(height: 12),

          const Text(
            'No Category Budgets',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF292747),
            ),
          ),

          const SizedBox(height: 5),

          Text(
            'Create budgets for categories like Food,\n'
                'Transport, Shopping and more.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              height: 1.4,
              color: Colors.grey.shade600,
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
              foregroundColor: const Color(0xFF6557D9),
              side: const BorderSide(
                color: Color(0xFF6557D9),
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