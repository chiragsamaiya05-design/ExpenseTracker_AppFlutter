import '../database/expenses_DataBase.dart';
import '../models/expense_model.dart';
import '../models/monthly_finance_model.dart';

class ExpenseRepository {
  final ExpensesDatabase database;
  final int userId;

  ExpenseRepository({
    required this.database,
    required this.userId,
  });

  Future<List<Expense>> getExpenses() async {
    return await database.getExpense(userId);
  }

  Future<int> addExpense(Expense expense) async {
    return await database.insertExpense(expense,userId);
  }

  Future<int> updateExpense(Expense expense) async {
    return await database.updateExpense(expense,userId);
  }

  Future<int> deleteExpense(int id) async {
    return await database.deleteExpense(id,userId);
  }

  Future<Map<String, double>> getCategoryExpenses() async {
    return await database.getCategoryWiseExpense(userId);
  }

  Future<Map<String, double>> getCategoryWiseExpenseForMonth({
    required int month,
    required int year,
  }) async {
    return await database.getCategoryWiseExpenseForMonth(
      userId:userId,
      month: month,
      year: year,
    );
  }
  Future<Map<int, double>> getDailyExpenseForMonth({
    required int month,
    required int year,
  }) async {
    return await database.getDailyExpenseForMonth(
      userId:userId,
      month: month,
      year: year,
    );
  }
}