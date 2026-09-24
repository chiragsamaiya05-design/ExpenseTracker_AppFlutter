import 'package:expense_tracker/repositories/finance_repository.dart';
import 'package:flutter/cupertino.dart';


import '../../repositories/expense_repository.dart';
import '../../repositories/income_repository.dart';

mixin ExpenseIncomeMixin on ChangeNotifier{
  late  IncomeRepository incomeRepository;

  double monthlyIncome = 0;

  Future<void> loadIncome() async {
    final income = await incomeRepository.getMonthlyIncome();

    monthlyIncome = income ?? 0;

    notifyListeners();
  }

  Future<void> saveIncome(double income) async {
    await incomeRepository.saveMonthlyIncome(income);

    monthlyIncome = income;

    notifyListeners();
  }
}