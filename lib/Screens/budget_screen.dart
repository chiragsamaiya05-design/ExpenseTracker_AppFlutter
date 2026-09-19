import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/budget_controller.dart';
import 'add_budget_screen.dart';

class BudgetScreen extends StatelessWidget {
  const BudgetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<BudgetController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Budgets'),
      ),

      body: controller.isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : ListView.builder(
        itemCount: controller.budgets.length,
        itemBuilder: (context, index) {
          final budget = controller.budgets[index];
          final spend = controller.categoryExpenses[budget.category]??0.0;
          final per = budget.amount == 0 ? 0.0 : spend/budget.amount;
          final remaining = budget.amount - spend;
          final status = controller.getBudgetStatus(budget);

          return Card(
            margin: const EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Text(
                    budget.category,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: .bold,
                    ),
                  ),
                  const SizedBox(height: 10,),
                  
                  Text(
                    '${spend.toStringAsFixed(2)}/'
                      '${budget.amount.toStringAsFixed(2)}'
                  ),
                  const SizedBox(height: 10,),
                  
                  LinearProgressIndicator(
                    value: per.clamp(0.0, 1.0),
                  ),
                  
                  const SizedBox(height: 10,),
                  
                  Text('${(per*100).toStringAsFixed(0)}% Used'),

                  const SizedBox(height: 8),

                  if (status == 'warning')
                    const Text(
                      ' You are close to your budget limit',
                    ),

                  if (status == 'exceeded')
                    Text(
                      ' Exceeded by ₹${(-remaining).toStringAsFixed(2)}',
                    ),

                  if (status == 'normal')
                    Text(
                      'Remaining: ₹${remaining.toStringAsFixed(2)}',
                    ),

                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddBudgetScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}