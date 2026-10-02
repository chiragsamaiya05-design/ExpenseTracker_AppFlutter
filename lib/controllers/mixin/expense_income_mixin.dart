import 'package:expense_tracker/repositories/finance_repository.dart';
import 'package:flutter/cupertino.dart';



import '../../repositories/income_repository.dart';

mixin ExpenseIncomeMixin on ChangeNotifier{
  late  IncomeRepository incomeRepository;
  final now = DateTime.now();

  double monthlyIncome = 0;

  Future<void> loadIncome() async {

    final income = await incomeRepository.getMonthlyIncome(now.month,now.year);
    monthlyIncome = income ?? 0;
    notifyListeners();
  }

  Future<void> saveIncome(double income) async {
    await incomeRepository.saveMonthlyIncome(income,now.month,now.year);

    monthlyIncome = income;

    notifyListeners();
  }
}