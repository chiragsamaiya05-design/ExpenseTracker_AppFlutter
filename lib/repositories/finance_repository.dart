import '../database/expenses_DataBase.dart';
import '../models/monthly_finance_model.dart';

class FinanceRepository {
   final ExpensesDatabase database;

   FinanceRepository({
   required this.database,
});
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
}