import 'package:flutter/material.dart';

import '../models/expense_model.dart';
import '../database/expenses_DataBase.dart';
import 'home_screen.dart';
import '../controllers/expense_controller.dart';
import '../widgets/summary_card.dart';
import '../widgets/category_expense_item.dart';
import '../repositories/expense_repository.dart';

class SummaryScreen extends StatefulWidget {
  const SummaryScreen({super.key});

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  final ExpenseController controller = ExpenseController(
    repository: ExpenseRepository(
      database: ExpensesDatabase(),
    ),
  );
  String get currentMonthYear {
    final now = DateTime.now();
    const months = [
      "January", "February", "March", "April",
      "May", "June", "July", "August",
      "September", "October", "November", "December"
    ];

    return "${months[now.month - 1]} ${now.year}";
  }

  Future<void> loadData() async {
    await controller.loadExpenses();
    await controller.loadIncome();
    await controller.loadCategoryExpenses();

    setState(() {});
  }
  @override
  void initState() {
    super.initState();
    loadData();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Summary'),
      ),
      body: Padding(
        padding: EdgeInsetsGeometry.all(8),
        child: Column(
          children: [
            SummaryCard(
              monthYear: currentMonthYear,
              income: controller.monthlyIncome,
              expense: controller.totalExpense,
              balance: controller.totalBalance,
            ),

            const SizedBox(height: 10,),

            ...controller.categoryExpenses.entries.map((entry) {
              return CategoryExpenseItem(
                category: entry.key,
                amount: entry.value,
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}