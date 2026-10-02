import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'auth/screens/auth_gate.dart';
import 'auth/controllers/auth_controller.dart';
import 'auth/database/user_database.dart';
import 'auth/repositories/auth_repository.dart';
import 'auth/services/auth_session.dart';

import 'controllers/expense_controller.dart';
import 'controllers/budget_controller.dart';

import 'repositories/expense_repository.dart';
import 'repositories/budget_repository.dart';
import 'repositories/income_repository.dart';
import 'repositories/finance_repository.dart';
import 'repositories/app_repository.dart';

import 'database/expenses_DataBase.dart';
import 'database/app_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows ||
      Platform.isLinux ||
      Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  final userDatabase = UserDatabase();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthController(
            repository: AuthRepository(
              database: userDatabase,
            ),
            session: AuthSession(),
          ),
        ),
      ],
      child: const ExpenseTracker(),
    ),
  );
}

class ExpenseTracker extends StatelessWidget {
  const ExpenseTracker({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = context.watch<AuthController>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF6F8FC),

        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4F46A5),
        ),

        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF4F46A5),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),

      builder: (context, child) {
        // User is not logged in.
        // Don't create expense-related providers.
        if (!authController.isLoggedIn ||
            authController.currentUser?.id == null) {
          return child!;
        }

        final userId = authController.currentUser!.id!;

        final database = ExpensesDatabase(
          appDatabase: AppDatabase(),
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
              ),
            ),

            ChangeNotifierProvider(
              create: (_) => BudgetController(
                repository: BudgetRepository(
                  database: database,
                  userId: userId,
                ),
              ),
            ),
          ],

          // IMPORTANT:
          // child is the Navigator, so these providers
          // are now ABOVE every route.
          child: child!,
        );
      },

      home: const AuthGate(),
    );
  }
}