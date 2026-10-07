class DatabaseTables {
  static const String expense = '''
    CREATE TABLE expense(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id INTEGER NOT NULL,
      title TEXT,
      amount REAL,
      category TEXT,
      date TIMESTAMP
    )
  ''';

  static const String monthlyIncome = '''
    CREATE TABLE monthly_income(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id INTEGER NOT NULL,
      month INTEGER,
      year INTEGER,
      income REAL,
      UNIQUE(month, year)
    )
  ''';

  static const String budgets = '''
    CREATE TABLE budgets(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id INTEGER NOT NULL,
      category TEXT NOT NULL,
      amount REAL NOT NULL,
      month TEXT NOT NULL,
      UNIQUE(category, month)
    )
  ''';

  static const String monthlyFinance = '''
    CREATE TABLE monthly_finance(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id INTEGER NOT NULL,
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
  static const String dailyBudget = '''
    CREATE TABLE daily_budget(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id INTEGER NOT NULL,
      date TEXT NOT NULL,
      amount REAL NOT NULL,
      UNIQUE(user_id, date)
    )
  ''';
  static const String recurringExpenses = '''
    CREATE TABLE recurring_expenses (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT NOT NULL,
          amount REAL NOT NULL,
          category TEXT NOT NULL,
          frequency TEXT NOT NULL,
          start_date TEXT NOT NULL,
          next_due_date TEXT NOT NULL,
          end_date TEXT,
          is_active INTEGER NOT NULL DEFAULT 1,
          created_at TEXT NOT NULL
)
  ''';
}