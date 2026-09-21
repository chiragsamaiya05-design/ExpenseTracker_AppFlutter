import 'package:flutter/cupertino.dart';


import '../../models/monthly_finance_model.dart';
import '../../repositories/expense_repository.dart';

mixin ExpenseCarryForwardMixin on ChangeNotifier{
  late ExpenseRepository repository;

  MonthlyFinance? currentMonthlyFinance;

  double carryForward = 0;
  double debt = 0;
  double investment = 0;
  double availableFunds = 0;

  double pendingSettlementAmount = 0;
  bool pendingSettlementIsDebt = false;

  bool settlementRequired = false;
  bool settlementShown = false;


  Future<void> rejectCarryForward() async {
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
      year: previousMonth.year,

      income: previousFinance.income,
      totalExpense: previousFinance.totalExpense,
      remaining: previousFinance.remaining,

      carryForward: 0,
      debt: 0,
      investment: 0,

      carryForwardApproved: false,

      decision: 'discard',
    );

    await repository.saveMonthlyFinance(finance);

    carryForward = 0;
    debt = 0;
    investment = 0;

    pendingSettlementAmount = 0;
    pendingSettlementIsDebt = false;
    settlementRequired = false;

    notifyListeners();
  }

  Future<double> getPreviousCarryForward() async {
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

    return previousFinance?.carryForward ?? 0;
  }

  Future<void> approveCarryForward() async {
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

      carryForward: previousFinance.remaining,
      debt: 0,
      investment: 0,

      carryForwardApproved: true,

      decision: 'carry_forward',
    );

    await repository.saveMonthlyFinance(finance);

    carryForward = previousFinance.remaining;
    debt = 0;
    investment = 0;

    pendingSettlementAmount = 0;
    pendingSettlementIsDebt = false;
    settlementRequired = false;

    notifyListeners();
  }
}