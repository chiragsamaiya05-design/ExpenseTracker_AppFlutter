
import 'package:expense_tracker/controllers/mixin/expense_carry_forward_mixin.dart';
import 'package:expense_tracker/controllers/mixin/expense_crud_mixin.dart';
import 'package:expense_tracker/controllers/mixin/expense_debt_mixin.dart';
import 'package:expense_tracker/controllers/mixin/expense_filters_mixin.dart';
import 'package:expense_tracker/controllers/mixin/expense_income_mixin.dart';
import 'package:expense_tracker/controllers/mixin/expense_investment_mixin.dart';
import 'package:expense_tracker/controllers/mixin/expense_monthly_finance_mixin.dart';
import 'package:expense_tracker/controllers/mixin/expense_summary_mixin.dart';
import 'package:expense_tracker/controllers/mixin/reset_mixin.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../repositories/expense_repository.dart';
import '../models/expense_model.dart';
import '../models/monthly_summary_model.dart';
import '../models/monthly_finance_model.dart';

class ExpenseController extends ChangeNotifier
with ExpenseCrudMixin,
      ExpenseFiltersMixin,
      ExpenseIncomeMixin,
      ExpenseSummaryMixin,
      ExpenseCarryForwardMixin,
      ExpenseDebtMixin,
      ExpenseMonthlyFinanceMixin,
      ExpenseInvestmentMixin,
    ResetMixin {
  final ExpenseRepository repository;

  ExpenseController(this.repository){
    _initialize();
  }
  MonthlyFinance? currentMonthlyFinance;

  final List<Expense> expenses = [];




  double carryForward = 0;
  double debt = 0;
  double investment = 0;
  double availableFunds = 0;

  double pendingSettlementAmount = 0;
  bool pendingSettlementIsDebt = false;

  bool settlementRequired = false;
  bool settlementShown = false;

  Map<String, double> categoryExpenses = {};





  Future<void> _initialize() async {

    isLoading = true;
    notifyListeners();

    await loadExpenses();
    await loadIncome();
    await loadMonthlySummaries();

    await loadMonthlyFinance();
    await initializeCurrentMonth();
    await checkMonthlySettlement();

    isLoading = false;
    notifyListeners();

  }

  Future<void> initializeCurrentMonth() async {
    final income =
        await repository.getMonthlyIncome() ?? 0;

    monthlyIncome = income;

    final previousCarryForward =
    await getPreviousCarryForward();

    final previousDebt =
    await getPreviousDebt();

    carryForward = previousCarryForward;
    debt = previousDebt;

    availableFunds =
        monthlyIncome + carryForward - debt;

    notifyListeners();
  }

  Future<void> loadCategoryExpenses() async {
    categoryExpenses = await repository.getCategoryExpenses();

    notifyListeners();
  }





  Future<void> loadMonthlyFinance() async {
    final finance = await repository.getMonthlyFinance(
      DateTime.now().month,
      DateTime.now().year,
    );

    if (finance == null) {
      carryForward = 0;
      debt = 0;
      investment = 0;
      availableFunds = monthlyIncome;
      return;
    }

    carryForward = finance.carryForward;
    debt = finance.debt;
    investment = finance.investment;

    notifyListeners();
  }







  Future<void> checkMonthlySettlement() async {
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

    // No previous month record
    if (previousFinance == null) {
      pendingSettlementAmount = 0;
      pendingSettlementIsDebt = false;
      settlementRequired = false;

      notifyListeners();
      return;
    }

    // Previous month has an unresolved surplus
    if (previousFinance.remaining > 0 &&
        previousFinance.decision == null) {
      pendingSettlementAmount =
          previousFinance.remaining;

      pendingSettlementIsDebt = false;
      settlementRequired = true;

      notifyListeners();
      return;
    }

    // Previous month has an unresolved debt
    if (previousFinance.debt > 0 &&
        previousFinance.decision == null) {
      pendingSettlementAmount =
          previousFinance.debt;

      pendingSettlementIsDebt = true;
      settlementRequired = true;

      notifyListeners();
      return;
    }

    // Nothing is waiting for a decision
    pendingSettlementAmount = 0;
    pendingSettlementIsDebt = false;
    settlementRequired = false;

    notifyListeners();
  }

}