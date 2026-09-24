import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/expense_controller.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/category_expense_pie_chart.dart';
import '../widgets/daily_expense_line_chart.dart';

class ChartsScreen extends StatefulWidget {
  const ChartsScreen({super.key});

  @override
  State<ChartsScreen> createState() => _ChartsScreenState();
}

class _ChartsScreenState extends State<ChartsScreen> {
  late DateTime selectedMonth;
  @override
  void initState() {
    super.initState();

    selectedMonth = DateTime(
      DateTime.now().year,
      DateTime.now().month,
    );

    Future.microtask(() {
      _loadChartData();
    });
  }
  String _monthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return months[month - 1];
  }

  void _changeMonth(int value) {
    final now = DateTime.now();

    final newMonth = DateTime(
      selectedMonth.year,
      selectedMonth.month + value,
    );

    // Don't allow future months
    if (newMonth.year > now.year ||
        (newMonth.year == now.year &&
            newMonth.month > now.month)) {
      return;
    }

    setState(() {
      selectedMonth = newMonth;
    });

    _loadChartData();
  }
  bool _isLoading = false;
  Future<void> _loadChartData() async {
    setState(() {
      _isLoading = true;
    });

    final controller = context.read<ExpenseController>();

    try {
      await Future.wait([
        controller.loadChartCategoryExpenses(
          month: selectedMonth.month,
          year: selectedMonth.year,
        ),
        controller.loadDailyChartExpenses(
          month: selectedMonth.month,
          year: selectedMonth.year,
        ),
      ]);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ExpenseController>();

    final now = DateTime.now();

    final isCurrentMonth =
        selectedMonth.year == now.year &&
            selectedMonth.month == now.month;

    return Scaffold(
      appBar: const AppBarWidget(
        title: 'Charts',
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Month selector
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () => _changeMonth(-1),
                icon: const Icon(Icons.chevron_left),
              ),

              Text(
                '${_monthName(selectedMonth.month)} ${selectedMonth.year}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),


            IconButton(
                  onPressed: isCurrentMonth
                  ? null
                      : () => _changeMonth(1),
                  icon: const Icon(Icons.chevron_right),
                  ),
            ],
          ),

          const SizedBox(height: 20),

          // Category chart
          const Text(
            'Expense by Category',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: CategoryExpensePieChart(
                categoryExpenses: controller.categoryExpenses,
              ),
            ),
          ),

          const SizedBox(height: 30),

          // Daily expense chart
          const Text(
            'Daily Expenses',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: DailyExpenseLineChart(
                dailyExpenses: controller.dailyExpenses,
              ),
            ),
          ),
        ],
      ),
    );
  }
}