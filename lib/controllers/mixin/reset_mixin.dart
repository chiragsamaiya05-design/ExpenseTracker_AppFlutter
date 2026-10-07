import 'package:expense_tracker/repositories/app_repository.dart';
import 'package:expense_tracker/repositories/expense_repository.dart';
import 'package:flutter/cupertino.dart';

import '../../models/expense_model.dart';
import '../../models/monthly_finance_model.dart';
import '../../models/monthly_summary_model.dart';

mixin ResetMixin on ChangeNotifier{
  late AppRepository appRepository;

  MonthlyFinance? currentMonthlyFinance;

  final List<Expense> expenses = [];
  List<MonthlySummary> monthlySummaries = [];
  double monthlyIncome = 0;

  double carryForward = 0;
  double debt = 0;
  double investment = 0;
  double availableFunds = 0;

  double pendingSettlementAmount = 0;
  bool pendingSettlementIsDebt = false;

  bool settlementRequired = false;
  bool settlementShown = false;

  Map<String, double> categoryExpenses = {};

  Future<void> resetAllData() async {
    await appRepository.resetAllData();

    expenses.clear();
    monthlyIncome = 0;
    categoryExpenses.clear();

    carryForward = 0;
    debt = 0;
    investment = 0;
    availableFunds = 0;

    pendingSettlementAmount = 0;
    pendingSettlementIsDebt = false;
    settlementRequired = false;
    settlementShown = false;

    monthlySummaries.clear();

    notifyListeners();
  }
}