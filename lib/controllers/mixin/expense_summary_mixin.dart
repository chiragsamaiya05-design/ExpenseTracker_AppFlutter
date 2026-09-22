import 'package:flutter/cupertino.dart';

import '../../models/expense_model.dart';
import '../../models/monthly_summary_model.dart';
import '../../repositories/expense_repository.dart';

mixin ExpenseSummaryMixin on ChangeNotifier{
  late  ExpenseRepository repository;
  final List<Expense> expenses = [];
  double monthlyIncome = 0;
  List<MonthlySummary> monthlySummaries = [];


  double get totalExpense {
    final now = DateTime.now();
    return expenses
        .where((expense)=>
    expense.date.year == now.year &&
        expense.date.month == now.month)
        .fold(0.0, (sum, expense) => sum + expense.amount,
    );
  }


  double get totalBalance {
    return monthlyIncome - totalExpense;
  }

  Future<void> loadMonthlySummaries() async {
    final now = DateTime.now();

    final List<MonthlySummary> summaries = [];

    for (int i = 0; i < 6; i++) {
      final date = DateTime(
        now.year,
        now.month - i,
        1,
      );

      final month = date.month;
      final year = date.year;

      final income =
          await repository.getIncomeForMonth(month, year) ?? 0;

      final expense = expenses
          .where(
            (expense) =>
        expense.date.year == year &&
            expense.date.month == month,
      )
          .fold(
        0.0,
            (sum, expense) => sum + expense.amount,
      );

      // Only add month if it has income or expense
      if (income == 0 && expense == 0) {
        continue;
      }

      summaries.add(
        MonthlySummary(
          month: month,
          year: year,
          income: income,
          totalExpense: expense,
        ),
      );
    }

    monthlySummaries = summaries;

    notifyListeners();
  }

}