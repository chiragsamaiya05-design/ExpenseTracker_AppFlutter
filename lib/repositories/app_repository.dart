import '../database/expenses_DataBase.dart';

class AppRepository {
  final ExpensesDatabase database;

  AppRepository({
    required this.database,
  });

  // Reset all application data
  Future<void> resetAllData() async {
    await database.resetAllData();
  }
}