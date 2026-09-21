
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../repositories/expense_repository.dart';
import '../models/expense_model.dart';
import '../models/monthly_summary_model.dart';
import '../models/monthly_finance_model.dart';



class ExpenseController extends ChangeNotifier {
  final ExpenseRepository repository;

  ExpenseController(this.repository){
    _initialize();
  }
  MonthlyFinance? currentMonthlyFinance;

  final List<Expense> expenses = [];
  double monthlyIncome = 0;
  String searchText = "";
  String selectedSort = "Newest";
  String selectedCategory = "All";
  String selectedDate = "All";

  bool isLoading = false;
  String? errorMessage;
  bool isSearching = false;

  List<MonthlySummary> monthlySummaries = [];

  double carryForward = 0;
  double debt = 0;
  double investment = 0;
  double availableFunds = 0;

  double pendingSettlementAmount = 0;
  bool pendingSettlementIsDebt = false;

  bool settlementRequired = false;
  bool settlementShown = false;

  Map<String, double> categoryExpenses = {};

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

  Future<void> loadExpenses() async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final data = await repository.getExpenses();

      expenses.clear();
      expenses.addAll(data);
    } catch (e) {
      errorMessage = "Failed to load expenses";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadIncome() async {
    final income = await repository.getMonthlyIncome();

    monthlyIncome = income ?? 0;

    notifyListeners();
  }

  Future<void> loadCategoryExpenses() async {
    categoryExpenses = await repository.getCategoryExpenses();

    notifyListeners();
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

  Future<void> saveIncome(double income) async {
    await repository.saveMonthlyIncome(income);

    monthlyIncome = income;

    notifyListeners();
  }

  Future<void> addExpense(Expense expense) async {
    try {
      await repository.addExpense(expense);
      await loadExpenses();
    } catch (e) {
      errorMessage = "Failed to add expense";
      notifyListeners();
    }
  }

  Future<void> updateExpense(Expense expense) async {
    try {
      await repository.updateExpense(expense);
      await loadExpenses();
    } catch (e) {
      errorMessage = "Failed to update expense";
      notifyListeners();
    }
  }

  Future<void> deleteExpense(int id) async {
    try {
      await repository.deleteExpense(id);
      await loadExpenses();
    } catch (e) {
      errorMessage = "Failed to delete expense";
      notifyListeners();
    }
  }

  Future<void> resetAllData() async {
    await repository.resetAllData();

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

  void setCategory(String category) {
    selectedCategory = category;
    notifyListeners();
  }

  void setSearchText(String value) {
    searchText = value;
    notifyListeners();
  }

  void setFilters(String category, String sort, String date,) {
    selectedCategory = category;
    selectedSort = sort;
    selectedDate = date;

    notifyListeners();
  }

  void startSearch() {
    isSearching = true;
    notifyListeners();
  }

  void closeSearch() {
    isSearching = false;
    searchText = "";
    notifyListeners();
  }

  List<Expense> get recentTransactions {
    final result = List<Expense>.from(expenses);

    result.sort(
          (a, b) => b.date.compareTo(a.date),
    );

    return result;
  }

  List<Expense> get displayExpenses {
    final result = expenses.where((expense) {
      return expense.title
          .toLowerCase()
          .contains(searchText.toLowerCase());
    }).toList();

    // sorting...

    return result;
  }

  List<Expense> get allFilteredExpenses {
    List<Expense> result = List.from(expenses);

    if (selectedCategory != "All") {
      result = result.where((expense) {
        return expense.category == selectedCategory;
      }).toList();
    }


    final now = DateTime.now();

    if (selectedDate == "Today") {
      result = result.where((expense) {
        return expense.date.year == now.year &&
            expense.date.month == now.month &&
            expense.date.day == now.day;
      }).toList();
    }

    if (selectedDate == "Month") {
      result = result.where((expense) {
        return expense.date.year == now.year &&
            expense.date.month == now.month;
      }).toList();
    }


    if (selectedSort == "Newest") {
      result.sort((a, b) => b.date.compareTo(a.date));
    } else if (selectedSort == "Oldest") {
      result.sort((a, b) => a.date.compareTo(b.date));
    } else if (selectedSort == "Low") {
      result.sort((a, b) => a.amount.compareTo(b.amount));
    } else if (selectedSort == "High") {
      result.sort((a, b) => b.amount.compareTo(a.amount));
    }

    return result;
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

  Future<void> approveInvestment() async {
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
      investment: previousFinance.remaining,

      carryForwardApproved: false,

      decision: 'invest',
    );

    await repository.saveMonthlyFinance(finance);

    carryForward = 0;
    debt = 0;
    investment = previousFinance.remaining;

    pendingSettlementAmount = 0;
    pendingSettlementIsDebt = false;
    settlementRequired = false;

    notifyListeners();
  }

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