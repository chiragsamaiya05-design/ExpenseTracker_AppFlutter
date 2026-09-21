import 'package:flutter/cupertino.dart';

import '../../models/expense_model.dart';
import '../../repositories/expense_repository.dart';

mixin ExpenseIncomeMixin on ChangeNotifier{
  late  ExpenseRepository repository;

  double monthlyIncome = 0;

  Future<void> loadIncome() async {
    final income = await repository.getMonthlyIncome();

    monthlyIncome = income ?? 0;

    notifyListeners();
  }

  Future<void> saveIncome(double income) async {
    await repository.saveMonthlyIncome(income);

    monthlyIncome = income;

    notifyListeners();
  }
}