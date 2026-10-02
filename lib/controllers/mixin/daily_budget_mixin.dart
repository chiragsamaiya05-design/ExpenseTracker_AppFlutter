import 'package:flutter/foundation.dart';

import 'package:expense_tracker/repositories/daily_budget_repository.dart';
import 'package:expense_tracker/models/expense_model.dart';

mixin DailyBudgetMixin on ChangeNotifier {
  late DailyBudgetRepository dailyBudgetRepository;

  // ============================================================
  // STATE
  // ============================================================

  double dailyBudget = 0;

  bool isDailyBudgetLoading = false;

  // ============================================================
  // REQUIRED FROM EXPENSE CONTROLLER
  // ============================================================

  List<Expense> get expenses;

  // ============================================================
  // INITIALIZE REPOSITORY
  // ============================================================

  void initializeDailyBudgetRepository(
      DailyBudgetRepository repository,
      ) {
    dailyBudgetRepository = repository;
  }

  // ============================================================
  // TODAY'S DATE
  // ============================================================

  String get todayDate {
    final now = DateTime.now();

    return '${now.year}-'
        '${now.month.toString().padLeft(2, '0')}-'
        '${now.day.toString().padLeft(2, '0')}';
  }

  // ============================================================
  // LOAD TODAY'S BUDGET
  // ============================================================

  Future<void> loadDailyBudget() async {
    try {
      isDailyBudgetLoading = true;
      notifyListeners();

      dailyBudget =
          await dailyBudgetRepository.getDailyBudget(todayDate) ?? 0;

    } catch (e) {
      dailyBudget = 0;

      debugPrint(
        'Error loading daily budget: $e',
      );
    } finally {
      isDailyBudgetLoading = false;
      notifyListeners();
    }
  }

  // ============================================================
  // SAVE / UPDATE DAILY BUDGET
  // ============================================================

  Future<void> saveDailyBudget(double amount) async {
    if (amount <= 0) {
      return;
    }

    try {
      isDailyBudgetLoading = true;
      notifyListeners();

      await dailyBudgetRepository.saveDailyBudget(
        todayDate,
        amount,
      );

      dailyBudget = amount;
    } catch (e) {
      debugPrint(
        'Error saving daily budget: $e',
      );
    } finally {
      isDailyBudgetLoading = false;
      notifyListeners();
    }
  }

  // ============================================================
  // TODAY'S EXPENSE
  // ============================================================

  double get todayExpense {
    final now = DateTime.now();

    return expenses
        .where(
          (expense) =>
      expense.date.year == now.year &&
          expense.date.month == now.month &&
          expense.date.day == now.day,
    )
        .fold(
      0.0,
          (sum, expense) => sum + expense.amount,
    );
  }

  // ============================================================
  // REMAINING DAILY BUDGET
  // ============================================================

  double get dailyBudgetRemaining {
    final remaining = dailyBudget - todayExpense;

    return remaining > 0 ? remaining : 0;
  }

  // ============================================================
  // EXCEEDED AMOUNT
  // ============================================================

  double get dailyBudgetExceededAmount {
    if (!isDailyBudgetExceeded) {
      return 0;
    }

    return todayExpense - dailyBudget;
  }

  // ============================================================
  // BUDGET PERCENTAGE
  // ============================================================

  double get dailyBudgetPercentage {
    if (dailyBudget <= 0) {
      return 0;
    }

    return (todayExpense / dailyBudget).clamp(0.0, 1.0);
  }

  // ============================================================
  // EXCEEDED
  // ============================================================

  bool get isDailyBudgetExceeded {
    return dailyBudget > 0 &&
        todayExpense > dailyBudget;
  }

  // ============================================================
  // HAS DAILY BUDGET
  // ============================================================

  bool get hasDailyBudget {
    return dailyBudget > 0;
  }

  // ============================================================
  // STATUS
  // ============================================================

  String get dailyBudgetStatus {
    if (!hasDailyBudget) {
      return 'No Budget';
    }

    if (isDailyBudgetExceeded) {
      return 'Exceeded';
    }

    if (dailyBudgetPercentage >= 0.90) {
      return 'Almost Exceeded';
    }

    if (dailyBudgetPercentage >= 0.70) {
      return 'High Usage';
    }

    return 'On Track';
  }

}