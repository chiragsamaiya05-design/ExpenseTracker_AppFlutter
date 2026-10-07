import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/expense_controller.dart';

class MonthlySettlementDialog extends StatelessWidget {
  final double remaining;
  final double debt;

  const MonthlySettlementDialog({
    super.key,
    required this.remaining,
    required this.debt,
  });

  @override
  Widget build(BuildContext context) {
    final controller = context.read<ExpenseController>();

    final bool hasDebt = debt > 0;

    return AlertDialog(
      title: Text(
        hasDebt
            ? 'Previous Month Debt'
            : 'Monthly Balance',
      ),

      content: hasDebt
          ? _buildDebtContent()
          : _buildSurplusContent(),

      actions: hasDebt
          ? [
        // Carry debt forward
        TextButton(
          onPressed: () async {
            await controller.carryDebtForward(debt);

            if (context.mounted) {
              Navigator.pop(context);
            }
          },
          child: const Text(
            'Carry Debt',
          ),
        ),

        // Settle complete debt
        FilledButton(
          onPressed: () async {
            await controller.settleDebt(debt);

            if (context.mounted) {
              Navigator.pop(context);
            }
          },
          child: const Text(
            'Settle Debt',
          ),
        ),
      ]
          : [
        // Don't carry
        TextButton(
          onPressed: () async {
            await controller.rejectCarryForward();

            if (context.mounted) {
              Navigator.pop(context);
            }
          },
          child: const Text(
            'Don\'t Carry',
          ),
        ),

        // Invest
        OutlinedButton(
          onPressed: () async {
            await controller.approveInvestment();

            if (context.mounted) {
              Navigator.pop(context);
            }
          },
          child: const Text(
            'Invest',
          ),
        ),

        // Carry forward
        FilledButton(
          onPressed: () async {
            await controller.approveCarryForward();

            if (context.mounted) {
              Navigator.pop(context);
            }
          },
          child: const Text(
            'Carry Forward',
          ),
        ),
      ],
    );
  }

  Widget _buildSurplusContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'You finished last month with:',
        ),

        const SizedBox(height: 12),

        Text(
          '₹${remaining.toStringAsFixed(2)}',
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 16),

        const Text(
          'What would you like to do with this money?',
        ),
      ],
    );
  }

  Widget _buildDebtContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'You spent more than your available funds last month.',
        ),

        const SizedBox(height: 12),

        Text(
          '₹${debt.toStringAsFixed(2)}',
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 16),

        const Text(
          'How would you like to handle this debt?',
        ),
      ],
    );
  }
}