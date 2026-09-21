import 'package:flutter/cupertino.dart';

import '../../models/expense_model.dart';
import '../../models/monthly_finance_model.dart';
import '../../models/monthly_summary_model.dart';
import '../../repositories/expense_repository.dart';

mixin ExpenseDebtMixin  on ChangeNotifier{
  late ExpenseRepository repository;

  MonthlyFinance? currentMonthlyFinance;
  double monthlyIncome = 0;

  double carryForward = 0;
  double debt = 0;
  double investment = 0;
  double availableFunds = 0;

  double pendingSettlementAmount = 0;
  bool pendingSettlementIsDebt = false;

  bool settlementRequired = false;
  bool settlementShown = false;

  List<MonthlySummary> monthlySummaries = [];

  Future<double> getPreviousDebt() async {
    final now = DateTime.now();

    final previousMonth = DateTime(
      now.year,
      now.month - 1,
    );

    final previousFinance =
    await repository.getMonthlyFinance(
      previousMonth.month,
      previousMonth.year,
    );

    return previousFinance?.debt ?? 0;
  }

  Future<void> carryDebtForward(double debtAmount) async {
    if (debtAmount <= 0) return;

    final now = DateTime.now();

    final previousMonth = DateTime(
      now.year,
      now.month - 1,
    );

    final previousFinance =
    await repository.getMonthlyFinance(
      previousMonth.month,
      previousMonth.year,
    );

    if (previousFinance == null) return;

    final finance = MonthlyFinance(
      id: previousFinance.id,
      month: previousFinance.month,
      year: previousFinance.year,

      income: previousFinance.income,
      totalExpense: previousFinance.totalExpense,
      remaining: previousFinance.remaining,

      carryForward: 0,
      debt: debtAmount,
      investment: previousFinance.investment,

      carryForwardApproved: false,

      decision: 'debt_carried',
    );

    await repository.saveMonthlyFinance(finance);

    debt = debtAmount;
    carryForward = 0;
    investment = 0;

    pendingSettlementAmount = 0;
    pendingSettlementIsDebt = false;
    settlementRequired = false;

    availableFunds = monthlyIncome - debt;

    notifyListeners();
  }

  Future<void> settleDebt(double debtAmount) async {
    if (debtAmount <= 0) return;

    final now = DateTime.now();

    final previousMonth = DateTime(
      now.year,
      now.month - 1,
    );

    final previousFinance =
    await repository.getMonthlyFinance(
      previousMonth.month,
      previousMonth.year,
    );

    if (previousFinance == null) return;

    final finance = MonthlyFinance(
      id: previousFinance.id,
      month: previousFinance.month,
      year: previousFinance.year,

      income: previousFinance.income,
      totalExpense: previousFinance.totalExpense,
      remaining: previousFinance.remaining,

      carryForward: 0,
      debt: 0,
      investment: previousFinance.investment,

      carryForwardApproved: false,

      decision: 'debt_settled',
    );

    await repository.saveMonthlyFinance(finance);

    debt = 0;
    carryForward = 0;
    investment = 0;

    pendingSettlementAmount = 0;
    pendingSettlementIsDebt = false;
    settlementRequired = false;

    availableFunds = monthlyIncome;

    notifyListeners();
  }
}