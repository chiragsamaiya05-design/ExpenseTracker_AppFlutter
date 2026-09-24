class DatabaseTables {
  static const String expense = '''
    CREATE TABLE expense(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT,
      amount REAL,
      category TEXT,
      date TIMESTAMP
    )
  ''';

  static const String monthlyIncome = '''
    CREATE TABLE monthly_income(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      month INTEGER,
      year INTEGER,
      income REAL,
      UNIQUE(month, year)
    )
  ''';

  static const String budgets = '''
    CREATE TABLE budgets(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      category TEXT NOT NULL,
      amount REAL NOT NULL,
      month TEXT NOT NULL,
      UNIQUE(category, month)
    )
  ''';

  static const String monthlyFinance = '''
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
  ''';
}