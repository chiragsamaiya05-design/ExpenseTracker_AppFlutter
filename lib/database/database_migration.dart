import 'package:sqflite/sqflite.dart';

class DatabaseMigrations {
  static Future<void> upgrade(
      Database db,
      int oldVersion,
      int newVersion,
      ) async {
    // ============================================================
    // VERSION 1 → 2
    // MONTHLY INCOME
    // ============================================================
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

    // ============================================================
    // VERSION 2 → 3
    // BUDGETS
    // ============================================================
    if (oldVersion < 3) {
      await db.execute('''
        CREATE TABLE budgets(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          category TEXT NOT NULL,
          amount REAL NOT NULL,
          month TEXT NOT NULL,
          UNIQUE(category, month)
        )
      ''');
    }

    // ============================================================
    // VERSION 3 → 4
    // MONTHLY FINANCE
    // ============================================================
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

    // ============================================================
    // VERSION 4 → 5
    // ADD DECISION
    // ============================================================
    if (oldVersion < 5) {
      await db.execute(
        'ALTER TABLE monthly_finance ADD COLUMN decision TEXT',
      );
    }

    // ============================================================
    // VERSION 5 → 6
    // ADD USER ID
    // ============================================================
    if (oldVersion < 6) {
      await db.execute(
        'ALTER TABLE expense ADD COLUMN user_id INTEGER',
      );

      await db.execute(
        'ALTER TABLE monthly_income ADD COLUMN user_id INTEGER',
      );

      await db.execute(
        'ALTER TABLE budgets ADD COLUMN user_id INTEGER',
      );

      await db.execute(
        'ALTER TABLE monthly_finance ADD COLUMN user_id INTEGER',
      );
    }
  }
}