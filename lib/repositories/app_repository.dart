import '../database/expenses_DataBase.dart';

class AppRepository {
  final ExpensesDatabase database;
  final int userId;

  AppRepository({
    required this.database,
    required this.userId,
  });

  // Reset all application data
  Future<void> resetAllData() async {
    await database.resetAllData(userId);
  }
}