import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/expense_model.dart';
import 'package:expense_tracker/models/budget_model.dart';

class ExpensesDatabase {
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
      version: 3,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE expense(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            amount REAL,
            category TEXT,
            date TIMESTAMP
          )
        ''');
        await db.execute('''
    CREATE TABLE monthly_income(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      month INTEGER,
      year INTEGER,
      income REAL,
      UNIQUE(month,year)
    )
  ''');
        await db.execute('''
        CREATE TABLE budgets (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    category TEXT NOT NULL,
    amount REAL NOT NULL,
    month TEXT NOT NULL,
    UNIQUE(category, month)
)
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('''
      CREATE TABLE monthly_income(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        month INTEGER,
        year INTEGER,
        income REAL,
        UNIQUE(month, year)
      )
    ''');
        }
        if(oldVersion<3){
          await db.execute('''
           CREATE TABLE budgets (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    category TEXT NOT NULL,
    amount REAL NOT NULL,
    month TEXT NOT NULL,
    UNIQUE(category, month)
)
          ''');
        }
        },
);

    return _database!;
  }

  Future<int> insertExpense(Expense expense) async {
    final db = await database;

    return await db.insert(
      'expense',
      expense.toMap(),
    );
  }

  Future<List<Expense>> getExpense() async {
    final db = await database;

    final maps = await db.query('expense',orderBy: 'date DESC');

    return maps.map((map) {
      return Expense.fromMap(map);
    }).toList();
  }

  Future<int> updateExpense(Expense expense) async {
    final db = await database;

    return await db.update(
      'expense',
      expense.toMap(),
      where: 'id = ?',
      whereArgs: [expense.id],
    );
  }

  Future<int> deleteExpense(int id) async {
    final db = await database;

    return await db.delete(
      'expense',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> saveMonthlyIncome(double income) async {
    final db = await database;

    final now = DateTime.now();

    await db.insert(
      'monthly_income',
      {
        'month': now.month,
        'year': now.year,
        'income': income,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<double?> getMonthlyIncome() async {
    final db = await database;

    final now = DateTime.now();

    final result = await db.query(
      'monthly_income',
      where: 'month = ? AND year = ?',
      whereArgs: [
        now.month,
        now.year,
      ],
      limit: 1,
    );

    if (result.isEmpty) {
      return null;
    }

    return (result.first['income'] as num).toDouble();
  }

  Future<Map<String, double>> getCategoryWiseExpense() async {
    final db = await database;

    final result = await db.rawQuery('''
    SELECT category, SUM(amount) AS total
    FROM expense
    GROUP BY category
  ''');

    return {
      for (final row in result)
        row['category'] as String:
        (row['total'] as num).toDouble(),
    };
  }


  Future<int> insertBudget(Budget budget) async {
    final db = await database;

    return await db.insert(
      'budgets',
      budget.toMap(),
    );
  }

  Future<List<Budget>> getBudgets(String month) async {
    final db = await database;

    final result = await db.query(
      'budgets',
      where: 'month = ?',
      whereArgs: [month],
    );

    return result.map((map) => Budget.fromMap(map)).toList();
  }

  Future<int> updateBudget(Budget budget) async {
    final db = await database;

    return await db.update(
      'budgets',
      budget.toMap(),
      where: 'id = ?',
      whereArgs: [budget.id],
    );
  }

  Future<int> deleteBudget(int id) async {
    final db = await database;

    return await db.delete(
      'budgets',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<double> getCategoryExpense(String category, String startDate, String endDate,) async {
    final db = await database;

    final result = await db.rawQuery(
      '''
    SELECT SUM(amount) AS total
    FROM expense
    WHERE category = ?
    AND date BETWEEN ? AND ?
    ''',
      [category, startDate, endDate],
    );

    return (result.first['total'] as num?)?.toDouble() ?? 0.0;
  }

  Future<Map<String, double>> getMonthlyCategoryExpenses(String startDate, String endDate,) async {
    final db = await database;

    final result = await db.rawQuery(
      '''
    SELECT category, SUM(amount) AS total
    FROM expense
    WHERE date BETWEEN ? AND ?
    GROUP BY category
    ''',
      [startDate, endDate],
    );

    return {
      for (final row in result)
        row['category'] as String:
        (row['total'] as num).toDouble(),
    };
  }
}