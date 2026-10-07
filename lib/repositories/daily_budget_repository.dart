import 'package:expense_tracker/database/expenses_DataBase.dart';

class DailyBudgetRepository {
  final ExpensesDatabase database;
  final int userId;

  DailyBudgetRepository({
    required this.database,
    required this.userId,
  });

  Future<void> saveDailyBudget(
      String date,
      double amount,
      ) async {
    await database.saveDailyBudget(
      date,
      amount,
      userId,
    );
  }

  Future<double?> getDailyBudget(
      String date,
      ) async {
    return await database.getDailyBudget(
      date,
      userId,
    );
  }

  Future<int> deleteDailyBudget(
      String date,
      ) async {
    return await database.deleteDailyBudget(
      date,
      userId,
    );
  }
}