import 'package:expense_tracker/repositories/finance_repository.dart';
import 'package:flutter/cupertino.dart';



import '../../repositories/income_repository.dart';

mixin ExpenseIncomeMixin on ChangeNotifier{
  late  IncomeRepository incomeRepository;
  final now = DateTime.now();

  double monthlyIncome = 0;

  Future<void> loadIncome() async {
    debugPrint('CURRENT USER ID: ${incomeRepository.userId}');
    debugPrint('MONTH: ${now.month}');
    debugPrint('YEAR: ${now.year}');

    final income = await incomeRepository.getMonthlyIncome(now.month,now.year);

    debugPrint('LOADED INCOME: $income');

    monthlyIncome = income ?? 0;

    notifyListeners();
  }

  Future<void> saveIncome(double income) async {

    debugPrint(
      'SAVING INCOME: $income | '
          'USER: ${incomeRepository.userId} | '
          'MONTH: ${now.month} | '
          'YEAR: ${now.year}',
    );

    await incomeRepository.saveMonthlyIncome(income,now.month,now.year);

    monthlyIncome = income;

    notifyListeners();
  }
}