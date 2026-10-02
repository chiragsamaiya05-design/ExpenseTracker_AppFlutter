import '../database/expenses_DataBase.dart';
import '../models/monthly_finance_model.dart';

class FinanceRepository {
  final ExpensesDatabase database;
  final int userId;

  FinanceRepository({
    required this.database,
    required this.userId,
  });

  Future<MonthlyFinance?> getMonthlyFinance(
      int month,
      int year,
      ) async {
    return await database.getMonthlyFinance(
      month,
      year,
      userId,
    );
  }

  Future<int> saveMonthlyFinance(
      MonthlyFinance finance,
      ) async {
    return await database.saveMonthlyFinance(
      finance,
      userId,
    );
  }

  Future<int> updateMonthlyFinance(
      MonthlyFinance finance,
      ) async {
    return await database.updateMonthlyFinance(
      finance,
      userId,
    );
  }
}