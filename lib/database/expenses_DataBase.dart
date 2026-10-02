import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'app_database.dart';

import '../models/expense_model.dart';
import 'package:expense_tracker/models/budget_model.dart';

import '../models/monthly_finance_model.dart';

class ExpensesDatabase {
  final AppDatabase appDatabase;
  ExpensesDatabase({
    required this.appDatabase,
  });

  Future<Database> get database async {
    return await appDatabase.database;
  }

  Future<int> insertExpense(Expense expense,int userId) async {
    final db = await database;

    final data = expense.toMap();

    data['user_id'] = userId;

    return await db.insert(
      'expense',
      data,
    );
  }

  Future<List<Expense>> getExpense(int userId) async {
    final db = await database;

    final maps = await db.query('expense',where: 'user_id = ?',whereArgs: [userId], orderBy: 'date DESC');

    return maps.map((map) {
      return Expense.fromMap(map);
    }).toList();
  }

  Future<int> updateExpense(Expense expense,int userId) async {
    final db = await database;

    final data = expense.toMap();

    data.remove('user_id');

    return await db.update(
      'expense',
      data,
      where: 'id = ? AND user_id =?',
      whereArgs: [expense.id,userId],
    );
  }

  Future<int> deleteExpense(int id,int userId) async {
    final db = await database;

    return await db.delete(
      'expense',
      where: 'id = ? AND user_id =?',
      whereArgs: [id , userId],
    );
  }

  Future<int> saveMonthlyIncome(double income, int month, int year, int userId,) async {
    final db = await database;

    return await db.insert(
      'monthly_income',
      {
        'user_id': userId,
        'month': month,
        'year': year,
        'income': income,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<double> getMonthlyIncome(int month, int year, int userId,) async {
    final db = await database;

    final result = await db.query(
      'monthly_income',
      where: 'month = ? AND year = ? AND user_id = ?',
      whereArgs: [
        month,
        year,
        userId,
      ],
      limit: 1,
    );

    if (result.isEmpty) {
      return 0;
    }

    return (result.first['income'] as num).toDouble();
  }

  Future<Map<String, double>> getCategoryWiseExpense(int userId) async {
    final db = await database;

    final result = await db.rawQuery('''
    SELECT category, SUM(amount) AS total
    FROM expense
    WHERE user_id = ?
    GROUP BY category
  ''',
      [userId],
    );

    return {
      for (final row in result)
        row['category'] as String:
        (row['total'] as num).toDouble(),
    };
  }


  Future<int> insertBudget(Budget budget, int userId,) async {
    final db = await database;

    final data = budget.toMap();
    data['user_id'] = userId;

    return await db.insert(
      'budgets',
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Budget>> getBudgets(String month,int userId) async {
    final db = await database;

    final result = await db.query(
      'budgets',
      where: 'month =? AND user_id = ?',
      whereArgs: [month,userId],
      orderBy: 'id DESC',
    );

    return result.map((map) => Budget.fromMap(map)).toList();
  }

  Future<int> updateBudget(Budget budget, int userId,) async {
    final db = await database;

    final data = budget.toMap();
    data.remove('user_id');

    return await db.update(
      'budgets',
      data,
      where: 'id = ? AND user_id = ?',
      whereArgs: [
        budget.id,
        userId,
      ],
    );
  }

  Future<int> deleteBudget(int id, int userId,) async {
    final db = await database;

    return await db.delete(
      'budgets',
      where: 'id = ? AND user_id = ?',
      whereArgs: [
        id,
        userId,
      ],
    );
  }

  Future<double> getCategoryExpense(String category, String startDate, String endDate, int userId) async {
    final db = await database;

    final result = await db.rawQuery(
      '''
    SELECT SUM(amount) AS total
    FROM expense
    WHERE category = ?
    AND date BETWEEN ? AND ?
    AND user_id = ?
    ''',
      [category, startDate, endDate,userId],
    );

    return (result.first['total'] as num?)?.toDouble() ?? 0.0;
  }

  Future<Map<String, double>> getMonthlyCategoryExpenses(String startDate, String endDate,int userId) async {
    final db = await database;

    final result = await db.rawQuery(
      '''
    SELECT category, SUM(amount) AS total
    FROM expense
    WHERE date BETWEEN ? AND ?
    AND user_id = ?
    GROUP BY category
    ''',
      [startDate, endDate,userId],
    );

    return {
      for (final row in result)
        row['category'] as String:
        (row['total'] as num).toDouble(),
    };
  }


  Future<Budget?> getBudgetByCategory(String category, String month,int userId) async {
    final db = await database;

    final result = await db.query(
      'budgets',
      where: 'category = ? AND month = ? AND user_id = ?',
      whereArgs: [category, month,userId],
      limit: 1,
    );

    if (result.isEmpty) {
      return null;
    }

    return Budget.fromMap(result.first);
  }

  Future<void> resetAllData(int userId) async {
    final db = await database;

    await db.delete(
      'expense',
      where: 'user_id = ?',
      whereArgs: [userId],
    );

    await db.delete(
      'monthly_income',
      where: 'user_id = ?',
      whereArgs: [userId],
    );

    await db.delete(
      'budgets',
      where: 'user_id = ?',
      whereArgs: [userId],
    );

    await db.delete(
      'monthly_finance',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
  }

  Future<double?> getIncomeForMonth(int month, int year,int userId) async {
    final db = await database;

    final result = await db.query(
      'monthly_income',
      where: 'month = ? AND year = ? AND user_id = ?',
      whereArgs: [month, year,userId],
    );

    if (result.isEmpty) {
      return null;
    }

    return (result.first['income'] as num).toDouble();
  }

  Future<int> saveMonthlyFinance(MonthlyFinance finance, int userId,) async {
    final db = await database;

    final data = finance.toMap();

    data['user_id'] = userId;

    return await db.insert(
      'monthly_finance',
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<MonthlyFinance?> getMonthlyFinance(int month, int year, int userId,) async {
    final db = await database;

    final result = await db.query(
      'monthly_finance',
      where: 'month = ? AND year = ? AND user_id = ?',
      whereArgs: [
        month,
        year,
        userId,
      ],
      limit: 1,
    );

    if (result.isEmpty) {
      return null;
    }

    return MonthlyFinance.fromMap(result.first);
  }


  Future<Map<String, double>> getCategoryWiseExpenseForMonth({required int userId, required int month, required int year,}) async {
    final db = await database;

    final result = await db.rawQuery(
      '''
    SELECT category, SUM(amount) AS total
    FROM expense
    WHERE user_id = ?
    AND  strftime('%m', date) = ?
      AND strftime('%Y', date) = ?
    GROUP BY category
    ''',
      [
        userId,
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

  Future<Map<int, double>> getDailyExpenseForMonth({required int month, required int year, required int userId,}) async {
    final db = await database;

    final result = await db.rawQuery(
      '''
    SELECT 
      CAST(strftime('%d', date) AS INTEGER) AS day,
      SUM(amount) AS total
    FROM expense
    WHERE user_id = ?
    AND strftime('%m', date) = ?
      AND strftime('%Y', date) = ?
    GROUP BY strftime('%d', date)
    ORDER BY day
    ''',
      [
        userId,
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

  Future<int> updateMonthlyFinance(MonthlyFinance finance, int userId,) async {
    final db = await database;

    final data = finance.toMap();
    data.remove('user_id');

    return await db.update(
      'monthly_finance',
      data,
      where: 'id = ? AND user_id = ?',
      whereArgs: [
        finance.id,
        userId,
      ],
    );
  }

}