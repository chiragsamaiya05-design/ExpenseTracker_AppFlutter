import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DailyExpenseLineChart extends StatelessWidget {
  final Map<int, double> dailyExpenses;

  const DailyExpenseLineChart({
    super.key,
    required this.dailyExpenses,
  });

  @override
  Widget build(BuildContext context) {
    if (dailyExpenses.isEmpty) {
      return const Center(
        child: Text('No expense data available'),
      );
    }

    final spots = dailyExpenses.entries.map((entry) {
      return FlSpot(
        entry.key.toDouble(),
        entry.value,
      );
    }).toList();

    final maxExpense = dailyExpenses.values.reduce(
          (a, b) => a > b ? a : b,
    );

    return Column(
      children: [
        Row(
          crossAxisAlignment: .center,
          children: [
            RotatedBox(
                quarterTurns: 3,
        child: const Text(
          'Expense',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        ),

        const SizedBox(width: 8),

        Expanded(
              child: SizedBox(
                height: 350,
                child: LineChart(
                  LineChartData(
                    minX: 1,
                    maxX: 33,
                    minY: 0,
                    maxY: maxExpense == 0 ? 100 : maxExpense * 1.2,

                    gridData: const FlGridData(
                      show: false,
                    ),

                    borderData: FlBorderData(
                      show: false,
                    ),

                    titlesData: FlTitlesData(
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: false,
                        ),
                      ),

                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: false,
                        ),
                      ),

                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 31,
                          interval: 5,
                          getTitlesWidget: (value, meta) {
                            final day = value.toInt();
                            if (day > 30) {
                              return const SizedBox.shrink();
                            }
                            return Padding(
                              padding: const EdgeInsets.only(top: 6.0),
                              child: Text(
                                '$day',
                                style: const TextStyle(
                                  fontSize: 9,
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 55,
                          interval: maxExpense > 1000
                              ? 500
                              : maxExpense > 500
                              ? 100
                              : 50,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              '₹${value.toInt()}',
                              style: const TextStyle(
                                fontSize: 8,
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    lineBarsData: [
                      LineChartBarData(
                        spots: spots,
                        isCurved: true,
                        barWidth: 3,

                        dotData: const FlDotData(
                          show: true,
                        ),

                        belowBarData: BarAreaData(
                          show: false,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
    const SizedBox(height: 8),

    const Text(
    'Day',
    style: TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,),),
      ],
    );
  }
}