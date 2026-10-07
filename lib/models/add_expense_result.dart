import 'expense_model.dart';

class AddExpenseResult {
  final Expense expense;

  final bool isRecurring;
  final String? recurringFrequency;
  final DateTime? recurringEndDate;

  const AddExpenseResult({
    required this.expense,
    this.isRecurring = false,
    this.recurringFrequency,
    this.recurringEndDate,
  });
}