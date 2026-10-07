import '../database/expenses_DataBase.dart';

class IncomeRepository {
  final ExpensesDatabase database;
  final int userId;

  IncomeRepository({
   required this.database,
    required this.userId,
});
  Future<void> saveMonthlyIncome(double income,int month,int year,) async {
    await database.saveMonthlyIncome(income,month,year,userId,);
  }

  Future<double?> getMonthlyIncome(int month,int year) async {
    return await database.getMonthlyIncome(month,year,userId,);
  }

  Future<double?> getIncomeForMonth(int month, int year,) {
    return database.getIncomeForMonth(month, year,userId);
  }
}