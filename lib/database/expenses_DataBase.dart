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
      version: 5,
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
        await db.execute('''
  CREATE TABLE monthly_finance(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    month INTEGER NOT NULL,
    year INTEGER NOT NULL,

    income REAL NOT NULL DEFAULT 0,
    total_expense REAL NOT NULL DEFAULT 0,
    remaining REAL NOT NULL DEFAULT 0,

    carry_forward REAL NOT NULL DEFAULT 0,
    debt REAL NOT NULL DEFAULT 0,

    investment REAL NOT NULL DEFAULT 0,

    carry_forward_approved INTEGER NOT NULL DEFAULT 0,
    
    decision TEXT,

    UNIQUE(month, year)
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
        if (oldVersion < 4) {
          await db.execute('''
    CREATE TABLE monthly_finance(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      month INTEGER NOT NULL,
      year INTEGER NOT NULL,

      income REAL NOT NULL DEFAULT 0,
      total_expense REAL NOT NULL DEFAULT 0,
      remaining REAL NOT NULL DEFAULT 0,

      carry_forward REAL NOT NULL DEFAULT 0,
      debt REAL NOT NULL DEFAULT 0,

      investment REAL NOT NULL DEFAULT 0,

      carry_forward_approved INTEGER NOT NULL DEFAULT 0,

      

      UNIQUE(month, year)
    )
  ''');
        }

        if (oldVersion < 5) {
          await db.execute(
            'ALTER TABLE monthly_finance ADD COLUMN decision TEXT',
          );
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
  Future<Budget?> getBudgetByCategory(
      String category,
      String month,
      ) async {
    final db = await database;

    final result = await db.query(
      'budgets',
      where: 'category = ? AND month = ?',
      whereArgs: [category, month],
      limit: 1,
    );

    if (result.isEmpty) {
      return null;
    }

    return Budget.fromMap(result.first);
  }

  Future<void> resetAllData() async {
    final db = await database;

    await db.delete('expense');
    await db.delete('monthly_income');
    await db.delete('budgets');
    await db.delete('monthly_finance');
  }

  Future<double?> getIncomeForMonth(
      int month,
      int year,
      ) async {
    final db = await database;

    final result = await db.query(
      'monthly_income',
      where: 'month = ? AND year = ?',
      whereArgs: [month, year],
    );

    if (result.isEmpty) {
      return null;
    }

    return (result.first['income'] as num).toDouble();
  }

  Future<void> saveMonthlyFinance({required int month,
    required int year,
    required double income,
    required double totalExpense,
    required double remaining,
    required double carryForward,
    required double debt,
    required double investment,
    required bool carryForwardApproved,
    String? decision,
  }) async {
    final db = await database;

    await db.insert(
      'monthly_finance',
      {
        'month': month,
        'year': year,
        'income': income,
        'total_expense': totalExpense,
        'remaining': remaining,
        'carry_forward': carryForward,
        'debt': debt,
        'investment': investment,
        'carry_forward_approved':
        carryForwardApproved ? 1 : 0,
        'decision': decision,

      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, dynamic>?> getMonthlyFinance(
      int month,
      int year,
      ) async {
    final db = await database;

    final result = await db.query(
      'monthly_finance',
      where: 'month = ? AND year = ?',
      whereArgs: [month, year],
      limit: 1,
    );

    if (result.isEmpty) {
      return null;
    }

    return result.first;
  }

  Future<Map<String, double>> getCategoryWiseExpenseForMonth({
    required int month,
    required int year,
  }) async {
    final db = await database;

    final result = await db.rawQuery(
      '''
    SELECT category, SUM(amount) AS total
    FROM expense
    WHERE strftime('%m', date) = ?
      AND strftime('%Y', date) = ?
    GROUP BY category
    ''',
      [
        month.toString().padLeft(2, '0'),
        year.toString(),
      ],
    );

    return {
      for (final row in result)
        row['category'] as String:
        (row['total'] as num).toDouble(),
    };
  }
  Future<Map<int, double>> getDailyExpenseForMonth({
    required int month,
    required int year,
  }) async {
    final db = await database;

    final result = await db.rawQuery(
      '''
    SELECT 
      CAST(strftime('%d', date) AS INTEGER) AS day,
      SUM(amount) AS total
    FROM expense
    WHERE strftime('%m', date) = ?
      AND strftime('%Y', date) = ?
    GROUP BY strftime('%d', date)
    ORDER BY day
    ''',
      [
        month.toString().padLeft(2, '0'),
        year.toString(),
      ],
    );

    return {
      for (final row in result)
        row['day'] as int:
        (row['total'] as num).toDouble(),
    };
  }
}