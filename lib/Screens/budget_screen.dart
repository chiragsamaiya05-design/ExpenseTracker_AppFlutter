import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/budget_controller.dart';
import 'add_budget_screen.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final controller = context.read<BudgetController>();

      final now = DateTime.now();

      final month =
          '${now.year}-${now.month.toString().padLeft(2, '0')}';

      final startDate =
          '${now.year}-${now.month.toString().padLeft(2, '0')}-01';

      final lastDay =
          DateTime(now.year, now.month + 1, 0).day;

      final endDate =
          '${now.year}-${now.month.toString().padLeft(2, '0')}-$lastDay';

      controller.loadBudgets(month);

      controller.loadCategoryExpenses(
        startDate,
        endDate,
      );
    });
  }

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
                  
                  Text(
                    remaining >=0
                        ? 'Remaining ${remaining.toStringAsFixed(2)}'
                        : 'Exceed by ${(-remaining).toStringAsFixed(2)}'
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