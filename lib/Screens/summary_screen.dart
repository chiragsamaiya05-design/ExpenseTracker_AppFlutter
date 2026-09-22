import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../controllers/expense_controller.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/monthly_summary_card.dart';

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ExpenseController>();

    final summaries = controller.monthlySummaries.where((summary) {
      return summary.income != 0 ||
          summary.totalExpense != 0 ||
          summary.remaining != 0 ||
          summary.extraExpense != 0;
    }).toList();

    return Scaffold(
      appBar: const AppBarWidget(
        title: 'Summary',
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: summaries.length,
        itemBuilder: (context, index) {
          final summary = summaries[index];

          return MonthlySummaryCard(
            summary: summary,
          );
        },
      ),
    );
  }
}