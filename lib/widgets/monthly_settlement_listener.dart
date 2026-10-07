import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/expense_controller.dart';
import 'monthly_settlement_dialog.dart';

class MonthlySettlementListener extends StatefulWidget {
  final Widget child;

  const MonthlySettlementListener({
    super.key,
    required this.child,
  });

  @override
  State<MonthlySettlementListener> createState() =>
      _MonthlySettlementListenerState();
}

class _MonthlySettlementListenerState
    extends State<MonthlySettlementListener> {

  bool _dialogShown = false;

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ExpenseController>();

    // Settlement is no longer required.
    // Reset the local flag so a future settlement
    // can show the dialog again.
    if (!controller.settlementRequired) {
      _dialogShown = false;
    }

    if (controller.settlementRequired && !_dialogShown) {
      _dialogShown = true;

      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (!mounted) return;

        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return MonthlySettlementDialog(
              remaining: controller.pendingSettlementIsDebt
                  ? 0
                  : controller.pendingSettlementAmount,
              debt: controller.pendingSettlementIsDebt
                  ? controller.pendingSettlementAmount
                  : 0,
            );
          },
        );
      });
    }

    return widget.child;
  }
}