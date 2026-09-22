import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CategoryExpensePieChart extends StatelessWidget {
  final Map<String, double> categoryExpenses;

  const CategoryExpensePieChart({
    super.key,
    required this.categoryExpenses,
  });

  // Predefined category colors
  static const Map<String, Color> categoryColors = {
    'Food': Colors.orange,
    'Transport': Colors.blue,
    'Shopping': Colors.purple,
    'Bills': Colors.red,
    'Entertainment': Colors.pink,
    'Health': Colors.green,
    'Education': Colors.indigo,
    'Groceries': Colors.teal,
    'Travel': Colors.cyan,
    'Gym': Colors.deepOrange,
  };

  // Colors for custom categories
  static const List<Color> customColors = [
    Colors.amber,
    Colors.deepPurple,
    Colors.lightBlue,
    Colors.lightGreen,
    Colors.brown,
    Colors.blueGrey,
    Colors.lime,
    Colors.deepOrangeAccent,
  ];

  Color _getCategoryColor(String category, int index) {
    if (categoryColors.containsKey(category)) {
      return categoryColors[category]!;
    }

    return customColors[index % customColors.length];
  }
  String getShortCategory(String category) {
    if (category.length <= 8) {
      return category;
    }

    return '${category.substring(0, 5)}...';
  }

  @override
  Widget build(BuildContext context) {
    if (categoryExpenses.isEmpty) {
      return const Center(
        child: Text('No expense data available'),
      );
    }

    final entries = categoryExpenses.entries.toList();

    final totalExpense = entries.fold<double>(
      0,
          (sum, entry) => sum + entry.value,
    );

    final sections = entries.asMap().entries.map((entry) {
      final index = entry.key;
      final category = entry.value.key;
      final amount = entry.value.value;
      final percentage = (amount / totalExpense) * 100;

      return PieChartSectionData(
        value: amount,
        color: _getCategoryColor(category, index),
        radius: 80,
        title: '${getShortCategory(category)}\n'
            '${percentage.toStringAsFixed(1)}%',
        titleStyle:  TextStyle(
          fontSize: category.length > 10 ? 8 : 11,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        titlePositionPercentageOffset: 0.55
      );
    }).toList();

    return Column(
      children: [
        SizedBox(
          height: 300,
          child: PieChart(
            PieChartData(
              sections: sections,
              centerSpaceRadius: 45,
              sectionsSpace: 2,
            ),
          ),
        ),

        const SizedBox(height: 20),
        Text(
          'Total Expense',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),

        const SizedBox(height: 4),

        Text(
          '₹${totalExpense.toStringAsFixed(0)}',
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 20),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: entries.length,
          itemBuilder: (context, index) {
            final category = entries[index].key;
            final amount = entries[index].value;

            final color = _getCategoryColor(
              category,
              index,
            );
            return Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 6,
              ),
              child: Row(
                children: [
                  // COLOR DOT
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),

                  const SizedBox(width: 8),

                  // CATEGORY
                  Expanded(
                    child: Text(
                      category,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  // AMOUNT
                  Text(
                    '₹${amount.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                ],
              ),
            );
          },
        ),
      ],
    );
  }
}