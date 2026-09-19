class MonthlySummary {
  final int month;
  final int year;
  final double income;
  final double totalExpense;

  MonthlySummary({
    required this.month,
    required this.year,
    required this.income,
    required this.totalExpense,
  });

  double get remaining {
    final value = income - totalExpense;
    return value > 0 ? value : 0;
  }

  double get extraExpense {
    final value = totalExpense - income;
    return value > 0 ? value : 0;
  }
}