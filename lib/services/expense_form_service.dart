import '../models/add_expense_result.dart';
import '../models/expense_model.dart';

class ExpenseFormService {
  static AddExpenseResult? buildResult({
    required String title,
    required String amountText,
    required String category,
    required DateTime date,
    required bool isRecurring,
    required String recurringFrequency,
    required DateTime? recurringEndDate,
    int? expenseId,
  }) {
    final cleanTitle = title.trim();
    final amount = double.tryParse(amountText.trim());

    if (cleanTitle.isEmpty) {
      return null;
    }

    if (amount == null || amount <= 0) {
      return null;
    }

    final expense = Expense(
      id: expenseId,
      title: cleanTitle,
      amount: amount,
      category: category,
      date: date,
    );

    return AddExpenseResult(
      expense: expense,
      isRecurring: isRecurring,
      recurringFrequency:
      isRecurring ? recurringFrequency : null,
      recurringEndDate:
      isRecurring ? recurringEndDate : null,
    );
  }
}