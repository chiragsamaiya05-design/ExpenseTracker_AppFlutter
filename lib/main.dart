import 'dart:io';

import 'package:expense_tracker/Screens/main_navigation_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controllers/expense_controller.dart';
import 'controllers/budget_controller.dart';

import 'repositories/expense_repository.dart';
import 'repositories/budget_repository.dart';
import 'repositories/income_repository.dart';
import 'repositories/finance_repository.dart';
import 'repositories/app_repository.dart';

import 'database/expenses_DataBase.dart';

import 'Screens/home_screen.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'auth/controllers/auth_controller.dart';
import 'auth/repositories/auth_repository.dart';
import 'auth/database/user_database.dart';
import 'auth/screens/login_screen.dart';

void main(){
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  final database = ExpensesDatabase();
  final userDatabase = UserDatabase();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthController(
            repository: AuthRepository(
              database: userDatabase,
            ),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => ExpenseController(
            expenseRepository: ExpenseRepository(
              database: database,
            ),
            incomeRepository: IncomeRepository(
              database: database,
            ),
            financeRepository: FinanceRepository(
              database: database,
            ),
            appRepository: AppRepository(
              database: database,
            ),
          ),
        ),
          ChangeNotifierProvider(
          create: (_) => BudgetController(
          repository: BudgetRepository(
          database: ExpensesDatabase(),
          ),
          ),
  ),
        ],

        child: const ExpenseTracker(),


    ),
  );
}

class ExpenseTracker extends StatelessWidget{
  const ExpenseTracker ({super.key});

  @override
  Widget build(BuildContext context){
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

      home: const LoginScreen(),
    );
  }
}