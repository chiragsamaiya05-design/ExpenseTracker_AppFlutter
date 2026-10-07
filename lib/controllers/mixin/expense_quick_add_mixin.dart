import 'package:flutter/cupertino.dart';

import 'package:expense_tracker/repositories/expense_repository.dart';

import '../../models/expense_model.dart';

mixin ExpenseQuickAddMixin {
  late ExpenseRepository expenseRepository;

  late List<Expense>expenses;

  static const List<String> defaultQuickCategories = [
    'Food',
    'Transport',
    'Shopping',
    'Bills',
    'Entertainment'
  ];

  List<Expense> get recentExpensesForQuickAdd {
    final now = DateTime.now();
    final cutoffDate = now.subtract(const Duration(days: 30));

    return expenses.where((expense) {
      return expense.date.isAfter(cutoffDate);
    }).toList();
  }

  Map<String, int> get categoryFrequency {
    final frequency = <String, int>{};

    for (final expense in recentExpensesForQuickAdd) {
      frequency.update(
        expense.category,
            (count) => count + 1,
        ifAbsent: () => 1,
      );
    }

    return frequency;
  }

  List<String> get mostFrequentCategories {
    final categories = categoryFrequency.entries.toList();

    categories.sort(
          (a, b) => b.value.compareTo(a.value),
    );

    return categories.map((e) => e.key).toList();
  }

  List<String> get quickAddCategories {
    final result = <String>[
      ...mostFrequentCategories.take(4),
    ];

    for (final category in defaultQuickCategories) {
      if (result.length >= 4) break;

      if (!result.contains(category)) {
        result.add(category);
      }
    }

    return result;
  }
}