class MonthlyFinance {
  final int? id;
  final int month;
  final int year;

  final double income;
  final double totalExpense;
  final double remaining;

  final double carryForward;
  final double debt;
  final double investment;

  final bool carryForwardApproved;

  final String? decision;

  MonthlyFinance({
    this.id,
    required this.month,
    required this.year,
    required this.income,
    required this.totalExpense,
    required this.remaining,
    required this.carryForward,
    required this.debt,
    required this.investment,
    required this.carryForwardApproved,
    this.decision,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'month': month,
      'year': year,
      'income': income,
      'total_expense': totalExpense,
      'remaining': remaining,
      'carry_forward': carryForward,
      'debt': debt,
      'investment': investment,
      'carry_forward_approved':
      carryForwardApproved ? 1 : 0,
      'decision': decision,
    };
  }

  factory MonthlyFinance.fromMap(Map<String, dynamic> map) {
    return MonthlyFinance(
      id: map['id'],
      month: map['month'],
      year: map['year'],
      income: (map['income'] as num).toDouble(),
      totalExpense: (map['total_expense'] as num).toDouble(),
      remaining: (map['remaining'] as num).toDouble(),
      carryForward: (map['carry_forward'] as num).toDouble(),
      debt: (map['debt'] as num).toDouble(),
      investment: (map['investment'] as num).toDouble(),
      carryForwardApproved:
      map['carry_forward_approved'] == 1,
      decision: map['decision'],
    );
  }
}