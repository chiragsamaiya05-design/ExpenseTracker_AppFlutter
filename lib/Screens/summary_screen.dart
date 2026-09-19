import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../controllers/expense_controller.dart';
import '../widgets/monthly_summary_card.dart';

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ExpenseController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Summary'),
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: controller.monthlySummaries.length,
        itemBuilder: (context, index) {
          final summary = controller.monthlySummaries[index];

          return MonthlySummaryCard(
            summary: summary,
          );
        },
      ),
    );
  }
}