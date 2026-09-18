
import 'package:flutter/foundation.dart';

import '../repositories/expense_repository.dart';
import '../models/expense_model.dart';

class ExpenseController extends ChangeNotifier {
  final ExpenseRepository repository;
  ExpenseController({
    required this.repository,
  });
  final List<Expense> expenses = [];
  double monthlyIncome = 0;
  String searchText = "";
  String selectedSort = "Newest";
  String selectedCategory = "All";
  String selectedDate = "All";
  bool isLoading = false;
  String? errorMessage;

  double get totalExpense {
    return expenses.fold(
      0,
          (sum, expense) => sum + expense.amount,
    );
  }

  double get totalBalance {
    return monthlyIncome - totalExpense;
  }

  void setCategory(String category) {
    selectedCategory = category;
    notifyListeners();
  }

 Future<void> loadExpenses() async{
    try{
      isLoading = true;
      errorMessage =null;
      notifyListeners();
      final data = await repository.getExpenses();
      expenses.clear();
      expenses.addAll(data);
    }catch(e){
      errorMessage = "Failed to load expenses";
    }finally{
      isLoading = false;
      notifyListeners();
 }
 }

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

  Future<void> addExpense(Expense expense) async {
    try {
      await repository.addExpense(expense);
      await loadExpenses();
    }catch(e){
      errorMessage = "Failed to add expense";
      notifyListeners();
    }
  }

  Future<void> updateExpense(Expense expense) async {
    try {
      await repository.updateExpense(expense);
      await loadExpenses();
    }catch(e){
      errorMessage = "Failed to update expense";
      notifyListeners();
    }
  }

  Future<void> deleteExpense(int id) async {
    try {
      await repository.deleteExpense(id);
      await loadExpenses();
    }catch(e){
      errorMessage = "Failed to delete expense";
      notifyListeners();
    }
  }

  List<Expense> get displayExpenses {
    final result = expenses.where((expense) {
      return expense.title
          .toLowerCase()
          .contains(searchText.toLowerCase());
    }).toList();

    if (selectedSort == "Newest") {
      result.sort((a, b) => b.date.compareTo(a.date));
    } else if (selectedSort == "Oldest") {
      result.sort((a, b) => a.date.compareTo(b.date));
    } else if (selectedSort == "Highest") {
      result.sort((a, b) => b.amount.compareTo(a.amount));
    } else if (selectedSort == "Lowest") {
      result.sort((a, b) => a.amount.compareTo(b.amount));
    }

    return result;
  }
  Map<String, double> categoryExpenses = {};

  Future<void> loadCategoryExpenses() async {
    categoryExpenses = await repository.getCategoryExpenses();

    notifyListeners();
  }


  List<Expense> get allFilteredExpenses {
    List<Expense> result = List.from(expenses);

    // Category
    if (selectedCategory != "All") {
      result = result.where((expense) {
        return expense.category == selectedCategory;
      }).toList();
    }

    // Date
    final now = DateTime.now();

    if (selectedDate == "Today") {
      result = result.where((expense) {
        return expense.date.year == now.year &&
            expense.date.month == now.month &&
            expense.date.day == now.day;
      }).toList();
    }

    if (selectedDate == "Month") {
      result = result.where((expense) {
        return expense.date.year == now.year &&
            expense.date.month == now.month;
      }).toList();
    }

    // Sort
    if (selectedSort == "Newest") {
      result.sort((a, b) => b.date.compareTo(a.date));
    } else if (selectedSort == "Oldest") {
      result.sort((a, b) => a.date.compareTo(b.date));
    } else if (selectedSort == "Low") {
      result.sort((a, b) => a.amount.compareTo(b.amount));
    } else if (selectedSort == "High") {
      result.sort((a, b) => b.amount.compareTo(a.amount));
    }

    return result;
  }
  void setSearchText(String value) {
    searchText = value;
    notifyListeners();
  }

  void setFilters(
      String category,
      String sort,
      String date,
      ) {
    selectedCategory = category;
    selectedSort = sort;
    selectedDate = date;

    notifyListeners();
  }
}