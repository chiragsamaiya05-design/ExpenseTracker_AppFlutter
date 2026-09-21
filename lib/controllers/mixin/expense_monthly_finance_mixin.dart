import 'package:flutter/cupertino.dart';

import 'package:expense_tracker/repositories/expense_repository.dart';

mixin ExpenseMonthlyFinanceMixin on ChangeNotifier{
  late ExpenseRepository repository;

  double pendingSettlementAmount = 0;
  bool pendingSettlementIsDebt = false;

  bool settlementRequired = false;


  Future<void> checkMonthlySettlement() async {
    final now = DateTime.now();

    final previousMonth = DateTime(
      now.year,
      now.month - 1,
    );

    final previousFinance =
    await repository.getMonthlyFinance(
      previousMonth.month,
      previousMonth.year,
    );

    // No previous month record
    if (previousFinance == null) {
      pendingSettlementAmount = 0;
      pendingSettlementIsDebt = false;
      settlementRequired = false;

      notifyListeners();
      return;
    }

    // Previous month has an unresolved surplus
    if (previousFinance.remaining > 0 &&
        previousFinance.decision == null) {
      pendingSettlementAmount =
          previousFinance.remaining;

      pendingSettlementIsDebt = false;
      settlementRequired = true;

      notifyListeners();
      return;
    }

    // Previous month has an unresolved debt
    if (previousFinance.debt > 0 &&
        previousFinance.decision == null) {
      pendingSettlementAmount =
          previousFinance.debt;

      pendingSettlementIsDebt = true;
      settlementRequired = true;

      notifyListeners();
      return;
    }

    // Nothing is waiting for a decision
    pendingSettlementAmount = 0;
    pendingSettlementIsDebt = false;
    settlementRequired = false;

    notifyListeners();
  }
}