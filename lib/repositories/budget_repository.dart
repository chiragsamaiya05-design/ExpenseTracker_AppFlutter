import 'package:expense_tracker/database/expenses_DataBase.dart';
import 'package:expense_tracker/models/budget_model.dart';

class BudgetRepository {
  final ExpensesDatabase database;
  final int userId;

  BudgetRepository({
   required this.database,
    required this.userId,
});

  Future<List<Budget>> getBudget(String month) async{
    return await database.getBudgets(month,userId);
  }

  Future<int> addBudget(Budget budget) async{
    return await database.insertBudget(budget,userId);
  }

  Future<int> updateBudget(Budget budget) async{
    return await database.updateBudget(budget,userId);
  }

  Future<int> deleteBudget( int id) async{
    return await database.deleteBudget(id,userId);
  }

  Future<double> getCategoryExpenses( String category, String startDate, String endDate,) async{
    return await database.getCategoryExpense(category, startDate, endDate,userId);
  }

  Future<Map<String, double>> getMonthlyCategoryExpenses(
      String startDate,
      String endDate,
      ) async {
    return await database.getMonthlyCategoryExpenses(
      startDate,
      endDate,
      userId
    );
  }
  Future<Budget?> getBudgetByCategory(
      String category,
      String month,
      ) async {
    return await database.getBudgetByCategory(
      category,
      month,
      userId
    );
  }

}