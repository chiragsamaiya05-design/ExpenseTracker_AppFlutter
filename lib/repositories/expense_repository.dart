import '../database/expenses_DataBase.dart';
import '../models/expense_model.dart';
import '../models/monthly_finance_model.dart';

class ExpenseRepository {
  final ExpensesDatabase database;

  ExpenseRepository({
    required this.database,
  });

  Future<List<Expense>> getExpenses() async {
    return await database.getExpense();
  }

  Future<int> addExpense(Expense expense) async {
    return await database.insertExpense(expense);
  }

  Future<int> updateExpense(Expense expense) async {
    return await database.updateExpense(expense);
  }

  Future<int> deleteExpense(int id) async {
    return await database.deleteExpense(id);
  }

  Future<Map<String, double>> getCategoryExpenses() async {
    return await database.getCategoryWiseExpense();
  }

  Future<Map<String, double>> getCategoryWiseExpenseForMonth({
    required int month,
    required int year,
  }) async {
    return await database.getCategoryWiseExpenseForMonth(
      month: month,
      year: year,
    );
  }
  Future<Map<int, double>> getDailyExpenseForMonth({
    required int month,
    required int year,
  }) async {
    return await database.getDailyExpenseForMonth(
      month: month,
      year: year,
    );
  }
}