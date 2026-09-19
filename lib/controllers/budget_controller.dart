import 'package:flutter/foundation.dart';

import 'package:expense_tracker/repositories/budget_repository.dart';
import 'package:expense_tracker/models/budget_model.dart';

class BudgetController extends ChangeNotifier {
  final BudgetRepository repository;

  BudgetController({
    required this.repository,
});
  List<Budget> _budgets = [];
  List<Budget> get budgets => _budgets;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  Map<String, double> _categoryExpenses = {};
  Map<String, double> get categoryExpenses => _categoryExpenses;

  String get startDate {
    final now = DateTime.now();

    return '${now.year}-${now.month.toString().padLeft(2, '0')}-01';
  }

  String get endDate {
    final now = DateTime.now();

    final lastDay = DateTime(
      now.year,
      now.month + 1,
      0,
    ).day;

    return '${now.year}-${now.month.toString().padLeft(2, '0')}-$lastDay';
  }

  String get currentMonth {
    final now = DateTime.now();

    return '${now.year}-${now.month.toString().padLeft(2, '0')}';
  }



  Future<void> loadBudgets(String month) async {
    _isLoading = true;
    notifyListeners();

    _budgets = await repository.getBudget(month);

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addBudget(Budget budget) async {
    final existingBudget =
    await repository.getBudgetByCategory(
      budget.category,
      budget.month,
    );

    if (existingBudget != null) {
      final updatedBudget = Budget(
        id: existingBudget.id,
        category: budget.category,
        amount: budget.amount,
        month: budget.month,
      );

      await repository.updateBudget(updatedBudget);
    } else {
      await repository.addBudget(budget);
    }

    await loadBudgetData();
  }

  Future<void> updateBudget(Budget budget) async {
    await repository.updateBudget(budget);

    await loadBudgets(budget.month);
  }

  Future<void> deleteBudget(int id, String month) async {
    await repository.deleteBudget(id);

    await loadBudgets(month);
  }
  Future<double> getCategoryExpenses(String category, String startDate, String endDate,) async {
    return await repository.getCategoryExpenses(
      category,
      startDate,
      endDate,
    );
  }

  Future<void> loadCategoryExpenses(String startDate, String endDate,) async {
    _categoryExpenses = await repository.getMonthlyCategoryExpenses(
      startDate,
      endDate,
    );

    notifyListeners();
  }

  Future<void> loadBudgetData() async {
    _isLoading = true;
    notifyListeners();

    _budgets = await repository.getBudget(currentMonth);

    _categoryExpenses =
    await repository.getMonthlyCategoryExpenses(
      startDate,
      endDate,
    );

    _isLoading = false;
    notifyListeners();
  }
  Future<void> clearLocalData() async {
    budgets.clear();
    categoryExpenses.clear();

    notifyListeners();
  }

  String getBudgetStatus(Budget budget){
    final spend = _categoryExpenses[budget.category]??0.0;
    if (budget.amount == 0){
      return 'No Budget';
    }
    final per = spend /budget.amount;

    if (per >= 1.0){
      return 'exceed';
    }
    if (per >= 0.8){
      return 'Warning';
    }
    return 'normal';
  }

}