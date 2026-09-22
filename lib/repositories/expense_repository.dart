import '../database/expenses_DataBase.dart';
import '../models/expense_model.dart';
import '../models/monthly_finance_model.dart';

class ExpenseRepository {
  final ExpensesDatabase database;

  ExpenseRepository({
    required this.database,
  });

  Future<List<Expense>> getExpenses() async {
    return await database.getExpense();
  }

  Future<int> addExpense(Expense expense) async {
    return await database.insertExpense(expense);
  }

  Future<int> updateExpense(Expense expense) async {
    return await database.updateExpense(expense);
  }

  Future<int> deleteExpense(int id) async {
    return await database.deleteExpense(id);
  }

  Future<void> saveMonthlyIncome(double income) async {
    await database.saveMonthlyIncome(income);
  }

  Future<double?> getMonthlyIncome() async {
    return await database.getMonthlyIncome();
  }

  Future<Map<String, double>> getCategoryExpenses() async {
    return await database.getCategoryWiseExpense();
  }


  Future<void> resetAllData() async {
    await database.resetAllData();
  }

  Future<double?> getIncomeForMonth(int month, int year,) {
    return database.getIncomeForMonth(month, year);
  }

  Future<void> saveMonthlyFinance(MonthlyFinance finance) async{
    await database.saveMonthlyFinance(month: finance.month,
        year: finance.year,
        income: finance.income,
        totalExpense: finance.totalExpense,
        remaining: finance.remaining,
        carryForward: finance.carryForward,
        debt: finance.debt,
        investment: finance.investment,
        carryForwardApproved: finance.carryForwardApproved,

    );
  }

  Future<MonthlyFinance?>getMonthlyFinance(int month, int year,) async{
    final data = await database.getMonthlyFinance(month, year);

    if(data == null){
      return null;
    }
    return MonthlyFinance.fromMap(data);
  }

  Future<Map<String, double>> getCategoryWiseExpenseForMonth({
    required int month,
    required int year,
  }) async {
    return await database.getCategoryWiseExpenseForMonth(
      month: month,
      year: year,
    );
  }
  Future<Map<int, double>> getDailyExpenseForMonth({
    required int month,
    required int year,
  }) async {
    return await database.getDailyExpenseForMonth(
      month: month,
      year: year,
    );
  }
}