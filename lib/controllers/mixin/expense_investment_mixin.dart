import 'package:expense_tracker/repositories/expense_repository.dart';
import 'package:flutter/cupertino.dart';

import '../../models/monthly_finance_model.dart';
import '../../repositories/finance_repository.dart';

mixin ExpenseInvestmentMixin on ChangeNotifier{
  late FinanceRepository financeRepository;

  MonthlyFinance? currentMonthlyFinance;

  double carryForward = 0;
  double debt = 0;
  double investment = 0;
  double availableFunds = 0;

  double pendingSettlementAmount = 0;
  bool pendingSettlementIsDebt = false;

  bool settlementRequired = false;
  bool settlementShown = false;

  Future<void> approveInvestment() async {
    final now = DateTime.now();

    final previousMonth = DateTime(
      now.year,
      now.month - 1,
    );

    final previousFinance =
    await financeRepository.getMonthlyFinance(
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
      investment: previousFinance.remaining,

      carryForwardApproved: false,

      decision: 'invest',
    );

    await financeRepository.saveMonthlyFinance(finance);

    carryForward = 0;
    debt = 0;
    investment = previousFinance.remaining;

    pendingSettlementAmount = 0;
    pendingSettlementIsDebt = false;
    settlementRequired = false;

    notifyListeners();
  }
}