import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'database_tables.dart';
import 'database_migration.dart';

class AppDatabase {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await openDatabase(
      join(
        await getDatabasesPath(),
        'expenseDataBase.db',
      ),
      version: 5,
      onCreate: (db, version) async {
        await db.execute(DatabaseTables.expense);
        await db.execute(DatabaseTables.monthlyIncome);
        await db.execute(DatabaseTables.budgets);
        await db.execute(DatabaseTables.monthlyFinance);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        await DatabaseMigrations.upgrade(
          db,
          oldVersion,
          newVersion,
        );
      },
    );
    return _database!;
  }
}