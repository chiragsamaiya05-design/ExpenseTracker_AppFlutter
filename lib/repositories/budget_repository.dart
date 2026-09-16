import 'package:expense_tracker/database/expenses_DataBase.dart';
import 'package:expense_tracker/models/budget_model.dart';

class BudgetRepository {
  final ExpensesDatabase database;

  BudgetRepository({
   required this.database,
});

  Future<List<Budget>> getBudget(String month) async{
    return await database.getBudgets(month);
  }

  Future<int> addBudget(Budget budget) async{
    return await database.insertBudget(budget);
  }

  Future<int> updateBudget(Budget budget) async{
    return await database.updateBudget(budget);
  }

  Future<int> deleteBudget( int id) async{
    return await database.deleteBudget(id);
  }

  Future<double> getCategoryExpenses( String category, String startDate, String endDate,) async{
    return await database.getCategoryExpense(category, startDate, endDate);
  }

  Future<Map<String, double>> getMonthlyCategoryExpenses(
      String startDate,
      String endDate,
      ) async {
    return await database.getMonthlyCategoryExpenses(
      startDate,
      endDate,
    );
  }
}