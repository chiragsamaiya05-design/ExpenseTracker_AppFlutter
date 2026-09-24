import 'package:flutter/cupertino.dart';

import '../../models/expense_model.dart';
import '../../repositories/expense_repository.dart';

mixin ExpenseCrudMixin on ChangeNotifier {
  late ExpenseRepository expenseRepository;
  List<Expense> expenses = [];

  bool isLoading = false;
  String? errorMessage;

  Future<void> loadExpenses() async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final data = await expenseRepository.getExpenses();

      expenses.clear();
      expenses.addAll(data);
    } catch (e) {
      errorMessage = "Failed to load expenses";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addExpense(Expense expense) async {
    try {
      await expenseRepository.addExpense(expense);
      await loadExpenses();
    } catch (e) {
      errorMessage = "Failed to add expense";
      notifyListeners();
    }
  }

  Future<void> updateExpense(Expense expense) async {
    try {
      await expenseRepository.updateExpense(expense);
      await loadExpenses();
    } catch (e) {
      errorMessage = "Failed to update expense";
      notifyListeners();
    }
  }

  Future<void> deleteExpense(int id) async {
    try {
      await expenseRepository.deleteExpense(id);
      await loadExpenses();
    } catch (e) {
      errorMessage = "Failed to delete expense";
      notifyListeners();
    }
  }

}