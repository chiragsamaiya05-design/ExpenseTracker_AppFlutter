import 'package:flutter/material.dart';

import '../summary/summary_screen.dart';
import 'home_screen.dart';

import '../summary/charts_screen.dart';
import '../budget/budget_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: [
          HomeScreen(),
          const SummaryScreen(),
          const ChartsScreen(),
          const BudgetScreen(),
        ],
      ),
    );
  }
}