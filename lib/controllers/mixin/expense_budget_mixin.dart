import 'package:flutter/foundation.dart';
import 'package:expense_tracker/models/budget_model.dart';
import 'package:expense_tracker/repositories/budget_repository.dart';

import '../../models/expense_model.dart';

mixin ExpenseBudgetMixin on ChangeNotifier {
  late BudgetRepository budgetRepository;

  List<Budget> currentMonthBudgets = [];
  List<Expense> get expenses;

  bool isBudgetLoading = false;

  void initializeBudgetRepository(
      BudgetRepository repository,
      ) {
    budgetRepository = repository;
  }

  // ============================================================
  // CURRENT MONTH
  // ============================================================

  String get currentMonth {
    final now = DateTime.now();

    return '${now.year}-${now.month.toString().padLeft(2, '0')}';
  }

  // ============================================================
  // LOAD CURRENT MONTH BUDGET
  // ============================================================

  Future<void> loadCurrentMonthBudget() async {
    try {
      isBudgetLoading = true;
      notifyListeners();

      currentMonthBudgets =
      await budgetRepository.getBudget(currentMonth);
    } catch (e) {
      currentMonthBudgets = [];

      debugPrint(
        'Error loading current month budget: $e',
      );
    } finally {
      isBudgetLoading = false;
      notifyListeners();
    }
  }

  // ============================================================
  // TOTAL CURRENT MONTH BUDGET
  // ============================================================

  double get currentMonthBudget {
    return currentMonthBudgets.fold(
      0.0,
          (sum, budget) => sum + budget.amount,
    );
  }

  // ============================================================
  // CURRENT MONTH EXPENSE
  // ============================================================

  double get currentMonthBudgetUsed {
    final now = DateTime.now();

    return expenses
        .where(
          (expense) =>
      expense.date.year == now.year &&
          expense.date.month == now.month,
    )
        .fold(
      0.0,
          (sum, expense) => sum + expense.amount,
    );
  }

  // ============================================================
  // REMAINING BUDGET
  // ============================================================

  double get remainingBudget {
    final remaining =
        currentMonthBudget - currentMonthBudgetUsed;

    return remaining > 0 ? remaining : 0;
  }

  // ============================================================
  // BUDGET PERCENTAGE
  // ============================================================

  double get budgetPercentage {
    if (currentMonthBudget <= 0) {
      return 0;
    }

    return (currentMonthBudgetUsed / currentMonthBudget)
        .clamp(0.0, 1.0);
  }

  // ============================================================
  // BUDGET EXCEEDED
  // ============================================================

  bool get isBudgetExceeded {
    return currentMonthBudget > 0 &&
        currentMonthBudgetUsed > currentMonthBudget;
  }

  // ============================================================
  // HAS BUDGET
  // ============================================================

  bool get hasBudget {
    return currentMonthBudget > 0;
  }

  // ============================================================
  // BUDGET STATUS
  // ============================================================

  String get budgetStatus {
    if (!hasBudget) {
      return 'No Budget';
    }

    if (isBudgetExceeded) {
      return 'Exceeded';
    }

    if (budgetPercentage >= 0.90) {
      return 'Almost Exceeded';
    }

    if (budgetPercentage >= 0.70) {
      return 'High Usage';
    }

    return 'On Track';
  }

  // ============================================================
  // CATEGORY BUDGET
  // ============================================================

  double getCategoryBudget(String category) {
    return currentMonthBudgets
        .where(
          (budget) => budget.category == category,
    )
        .fold(
      0.0,
          (sum, budget) => sum + budget.amount,
    );
  }

  // ============================================================
  // CATEGORY EXPENSE
  // ============================================================

  double getCategoryBudgetUsed(String category) {
    final now = DateTime.now();

    return expenses
        .where(
          (expense) =>
      expense.category == category &&
          expense.date.year == now.year &&
          expense.date.month == now.month,
    )
        .fold(
      0.0,
          (sum, expense) => sum + expense.amount,
    );
  }

  // ============================================================
  // CATEGORY REMAINING
  // ============================================================

  double getCategoryBudgetRemaining(String category) {
    final remaining =
        getCategoryBudget(category) -
            getCategoryBudgetUsed(category);

    return remaining > 0 ? remaining : 0;
  }

  // ============================================================
  // CATEGORY PERCENTAGE
  // ============================================================

  double getCategoryBudgetPercentage(String category) {
    final budget = getCategoryBudget(category);

    if (budget <= 0) {
      return 0;
    }

    return (getCategoryBudgetUsed(category) / budget)
        .clamp(0.0, 1.0);
  }
}