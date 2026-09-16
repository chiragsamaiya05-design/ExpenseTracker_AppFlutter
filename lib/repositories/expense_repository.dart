import '../database/expenses_DataBase.dart';
import '../models/expense_model.dart';

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

  Future<void> saveMonthlyIncome(double income) async {
    await database.saveMonthlyIncome(income);
  }

  Future<double?> getMonthlyIncome() async {
    return await database.getMonthlyIncome();
  }

  Future<Map<String, double>> getCategoryExpenses() async {
    return await database.getCategoryWiseExpense();
  }
}