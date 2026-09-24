import '../database/expenses_DataBase.dart';

class IncomeRepository {
  final ExpensesDatabase database;

  IncomeRepository({
   required this.database,
});
  Future<void> saveMonthlyIncome(double income) async {
    await database.saveMonthlyIncome(income);
  }

  Future<double?> getMonthlyIncome() async {
    return await database.getMonthlyIncome();
  }

  Future<double?> getIncomeForMonth(int month, int year,) {
    return database.getIncomeForMonth(month, year);
  }
}