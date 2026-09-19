import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controllers/expense_controller.dart';
import 'controllers/budget_controller.dart';

import 'repositories/expense_repository.dart';
import 'repositories/budget_repository.dart';

import 'database/expenses_DataBase.dart';

import 'Screens/home_screen.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main(){
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  runApp(
    MultiProvider(
      providers: [
       ChangeNotifierProvider(
        create: (_) => ExpenseController(
           ExpenseRepository(
            database: ExpensesDatabase(),
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
      home:  HomeScreen(),
    );
  }
}