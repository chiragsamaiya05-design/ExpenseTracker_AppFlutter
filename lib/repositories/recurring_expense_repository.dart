import '../database/expenses_database.dart';
import '../models/recurring_expense_model.dart';

class RecurringExpenseRepository {
  final ExpensesDatabase _database;

  RecurringExpenseRepository(this._database);

  // Add recurring expense
  Future<int> addRecurringExpense(
      RecurringExpense recurringExpense,
      ) async {
    final db = await _database.database;

    return await db.insert(
      'recurring_expenses',
      recurringExpense.toMap(),
    );
  }

  // Get all recurring expenses
  Future<List<RecurringExpense>> getRecurringExpenses() async {
    final db = await _database.database;

    final result = await db.query(
      'recurring_expenses',
      orderBy: 'next_due_date ASC',
    );

    return result
        .map((map) => RecurringExpense.fromMap(map))
        .toList();
  }

  // Get only active recurring expenses
  Future<List<RecurringExpense>> getActiveRecurringExpenses() async {
    final db = await _database.database;

    final result = await db.query(
      'recurring_expenses',
      where: 'is_active = ?',
      whereArgs: [1],
      orderBy: 'next_due_date ASC',
    );

    return result
        .map((map) => RecurringExpense.fromMap(map))
        .toList();
  }

  // Get recurring expenses that are due
  Future<List<RecurringExpense>> getDueRecurringExpenses(
      DateTime date,
      ) async {
    final db = await _database.database;

    final result = await db.query(
      'recurring_expenses',
      where: '''
        is_active = ?
        AND next_due_date <= ?
      ''',
      whereArgs: [
        1,
        date.toIso8601String(),
      ],
      orderBy: 'next_due_date ASC',
    );

    return result
        .map((map) => RecurringExpense.fromMap(map))
        .toList();
  }

  // Update recurring expense
  Future<int> updateRecurringExpense(
      RecurringExpense recurringExpense,
      ) async {
    final db = await _database.database;

    return await db.update(
      'recurring_expenses',
      recurringExpense.toMap(),
      where: 'id = ?',
      whereArgs: [recurringExpense.id],
    );
  }

  // Delete recurring expense
  Future<int> deleteRecurringExpense(int id) async {
    final db = await _database.database;

    return await db.delete(
      'recurring_expenses',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Activate / deactivate
  Future<int> setActive(
      int id,
      bool isActive,
      ) async {
    final db = await _database.database;

    return await db.update(
      'recurring_expenses',
      {
        'is_active': isActive ? 1 : 0,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}