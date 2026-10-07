import 'package:flutter/foundation.dart';

import '../models/expense_model.dart';
import '../models/recurring_expense_model.dart';
import '../repositories/expense_repository.dart';
import '../repositories/recurring_expense_repository.dart';

class RecurringExpenseController extends ChangeNotifier {
  final RecurringExpenseRepository _repository;
  final ExpenseRepository _expenseRepository;

  RecurringExpenseController(
      this._repository,
      this._expenseRepository,
      );

  List<RecurringExpense> _recurringExpenses = [];

  bool _isLoading = false;
  String? _errorMessage;

  // -------------------------
  // Getters
  // -------------------------

  List<RecurringExpense> get recurringExpenses =>
      List.unmodifiable(_recurringExpenses);

  List<RecurringExpense> get activeRecurringExpenses =>
      _recurringExpenses.where((expense) => expense.isActive).toList();

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;


  DateTime _getNextDueDate(DateTime currentDate, String frequency,) {
    switch (frequency) {
      case 'daily':
        return currentDate.add(
          const Duration(days: 1),
        );

      case 'weekly':
        return currentDate.add(
          const Duration(days: 7),
        );

      case 'monthly':
        return DateTime(
          currentDate.year,
          currentDate.month + 1,
          currentDate.day,
        );

      case 'yearly':
        return DateTime(
          currentDate.year + 1,
          currentDate.month,
          currentDate.day,
        );

      default:
        return DateTime(
          currentDate.year,
          currentDate.month + 1,
          currentDate.day,
        );
    }
  }



  Future<void> loadRecurringExpenses() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _recurringExpenses =
      await _repository.getRecurringExpenses();
    } catch (e) {
      _errorMessage = 'Failed to load recurring expenses';
      debugPrint('loadRecurringExpenses error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }



  Future<bool> addRecurringExpense(
      RecurringExpense recurringExpense,
      ) async {
    try {
      // Calculate the next occurrence.
      final nextDueDate = _getNextDueDate(
        recurringExpense.startDate,
        recurringExpense.frequency,
      );

      // Save only the recurring rule.
      final recurringRule = recurringExpense.copyWith(
        nextDueDate: nextDueDate,
      );

      final id = await _repository.addRecurringExpense(
        recurringRule,
      );

      // Update local list.
      _recurringExpenses.add(
        recurringRule.copyWith(id: id),
      );

      notifyListeners();

      return true;
    } catch (e) {
      debugPrint(
        'addRecurringExpense error: $e',
      );

      _errorMessage =
      'Failed to add recurring expense';

      notifyListeners();

      return false;
    }
  }
  // -------------------------
  // Update
  // -------------------------

  Future<bool> updateRecurringExpense(
      RecurringExpense expense,
      ) async {
    try {
      await _repository.updateRecurringExpense(expense);

      final index = _recurringExpenses.indexWhere(
            (item) => item.id == expense.id,
      );

      if (index != -1) {
        _recurringExpenses[index] = expense;
      }

      notifyListeners();

      return true;
    } catch (e) {
      _errorMessage = 'Failed to update recurring expense';

      debugPrint('updateRecurringExpense error: $e');

      notifyListeners();

      return false;
    }
  }

  // -------------------------
  // Delete
  // -------------------------

  Future<bool> deleteRecurringExpense(int id) async {
    try {
      await _repository.deleteRecurringExpense(id);

      _recurringExpenses.removeWhere(
            (expense) => expense.id == id,
      );

      notifyListeners();

      return true;
    } catch (e) {
      _errorMessage = 'Failed to delete recurring expense';

      debugPrint('deleteRecurringExpense error: $e');

      notifyListeners();

      return false;
    }
  }

  // -------------------------
  // Activate / Deactivate
  // -------------------------

  Future<bool> toggleActive(
      RecurringExpense expense,
      ) async {
    try {
      final newStatus = !expense.isActive;

      await _repository.setActive(
        expense.id!,
        newStatus,
      );

      final updatedExpense = expense.copyWith(
        isActive: newStatus,
      );

      final index = _recurringExpenses.indexWhere(
            (item) => item.id == expense.id,
      );

      if (index != -1) {
        _recurringExpenses[index] = updatedExpense;
      }

      notifyListeners();

      return true;
    } catch (e) {
      _errorMessage = 'Failed to change recurring expense status';

      debugPrint('toggleActive error: $e');

      notifyListeners();

      return false;
    }
  }

  // -------------------------
  // Due Expenses
  // -------------------------

  Future<List<RecurringExpense>> getDueExpenses() async {
    try {
      return await _repository.getDueRecurringExpenses(
        DateTime.now(),
      );
    } catch (e) {
      debugPrint('getDueExpenses error: $e');
      return [];
    }
  }

  Future<void> _processRecurringExpense(
      RecurringExpense recurringExpense,
      ) async {
    DateTime dueDate =
        recurringExpense.nextDueDate;

    final today = DateTime.now();

    while (!dueDate.isAfter(today)) {
      // Create the actual expense.
      final expense = Expense(
        title: recurringExpense.title,
        amount: recurringExpense.amount,
        category: recurringExpense.category,
        date: dueDate,
      );

      await _expenseRepository.addExpense(
        expense,
      );

      // Calculate the next occurrence.
      dueDate = _getNextDueDate(
        dueDate,
        recurringExpense.frequency,
      );
    }

    // If the next occurrence is beyond the
    // end date, deactivate the recurring rule.
    if (recurringExpense.endDate != null &&
        dueDate.isAfter(
          recurringExpense.endDate!,
        )) {
      await _repository.setActive(
        recurringExpense.id!,
        false,
      );

      return;
    }

    // Update next due date.
    final updatedExpense =
    recurringExpense.copyWith(
      nextDueDate: dueDate,
    );

    await _repository.updateRecurringExpense(
      updatedExpense,
    );
  }

  Future<void> processDueExpenses() async {
    try {
      final dueExpenses =
      await _repository.getDueRecurringExpenses(
        DateTime.now(),
      );

      for (final recurringExpense in dueExpenses) {
        await _processRecurringExpense(
          recurringExpense,
        );
      }

      if (dueExpenses.isNotEmpty) {
        await loadRecurringExpenses();
      }
    } catch (e) {
      debugPrint(
        'processDueExpenses error: $e',
      );
    }
  }

  // -------------------------
  // Clear error
  // -------------------------

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}