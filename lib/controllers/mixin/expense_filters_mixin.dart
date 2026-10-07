import 'package:flutter/cupertino.dart';

import '../../models/expense_model.dart';
import '../../repositories/expense_repository.dart';

mixin ExpenseFiltersMixin on ChangeNotifier{
  late  ExpenseRepository repository;
  List<Expense> expenses = [];

  String searchText = "";
  String selectedSort = "Newest";
  String selectedCategory = "All";
  String selectedDate = "All";
  bool isSearching = false;

  void setCategory(String category) {
    selectedCategory = category;
    notifyListeners();
  }

  void setSearchText(String value) {
    searchText = value;
    notifyListeners();
  }

  void setFilters(String category, String sort, String date,) {
    selectedCategory = category;
    selectedSort = sort;
    selectedDate = date;

    notifyListeners();
  }

  void startSearch() {
    isSearching = true;
    notifyListeners();
  }

  void closeSearch() {
    isSearching = false;
    searchText = "";
    notifyListeners();
  }

  List<Expense> get recentTransactions {
    final result = List<Expense>.from(expenses);

    result.sort(
          (a, b) => b.date.compareTo(a.date),
    );

    return result;
  }

  List<Expense> get displayExpenses {
    final result = expenses.where((expense) {
      return expense.title
          .toLowerCase()
          .contains(searchText.toLowerCase());
    }).toList();

    // sorting...

    return result;
  }

  List<Expense> get allFilteredExpenses {
    List<Expense> result = List.from(expenses);

    if (selectedCategory != "All") {
      result = result.where((expense) {
        return expense.category == selectedCategory;
      }).toList();
    }


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
}