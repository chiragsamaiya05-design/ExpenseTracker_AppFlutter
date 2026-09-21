import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/expense_controller.dart';

class CarryForwardDialog {
  static Future<void> show(
      BuildContext context,
      double amount,
      ) async {
    final controller = context.read<ExpenseController>();

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Previous Month Balance',
          ),

          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'You have remaining funds from last month.',
              ),

              const SizedBox(height: 12),

              Text(
                '₹${amount.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              const Text(
                'What would you like to do with this money?',
              ),
            ],
          ),

          actions: [
            TextButton(
              onPressed: () async {
                await controller.rejectCarryForward();

                if (dialogContext.mounted) {
                  Navigator.pop(dialogContext);
                }
              },
              child: const Text(
                "Don't Carry",
              ),
            ),

            OutlinedButton(
              onPressed: () async {
                await controller.approveInvestment();

                if (dialogContext.mounted) {
                  Navigator.pop(dialogContext);
                }
              },
              child: const Text(
                'Invest',
              ),
            ),

            FilledButton(
              onPressed: () async {
                await controller.approveCarryForward();

                if (dialogContext.mounted) {
                  Navigator.pop(dialogContext);
                }
              },
              child: const Text(
                'Carry Forward',
              ),
            ),
          ],
        );
      },
    );
  }
}