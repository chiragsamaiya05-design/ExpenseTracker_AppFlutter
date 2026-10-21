import 'package:expense_tracker/repositories/app_repository.dart';
import 'package:expense_tracker/repositories/budget_repository.dart';
import 'package:expense_tracker/repositories/daily_budget_repository.dart';
import 'package:expense_tracker/repositories/expense_repository.dart';
import 'package:expense_tracker/repositories/finance_repository.dart';
import 'package:expense_tracker/repositories/income_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Screens/home/main_navigation_screen.dart';
import 'controllers/budget_controller.dart';
import 'controllers/expense_controller.dart';
import 'database/app_database.dart';
import 'database/expenses_DataBase.dart';

class UserProviders extends StatelessWidget {
  final int userId;

  const UserProviders({
    super.key,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    final database = ExpensesDatabase(
      appDatabase: AppDatabase(),
    );

    final budgetRepository = BudgetRepository(
      database: database,
      userId: userId,
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ExpenseController(
            expenseRepository: ExpenseRepository(
              database: database,
              userId: userId,
            ),
            incomeRepository: IncomeRepository(
              database: database,
              userId: userId,
            ),
            financeRepository: FinanceRepository(
              database: database,
              userId: userId,
            ),
            appRepository: AppRepository(
              database: database,
              userId: userId,
            ),
            budgetRepository: budgetRepository,
            dailyBudgetRepository: DailyBudgetRepository(
              database: database,
              userId: userId,
            ),
          ),
        ),

        ChangeNotifierProvider(
          create: (_) => BudgetController(
            repository: budgetRepository,
          ),
        ),
      ],

      child: Navigator(
        onGenerateRoute: (settings) {
          return MaterialPageRoute(
            builder: (_) => const MainNavigationScreen(),
          );
        },
      ),
    );
  }
}