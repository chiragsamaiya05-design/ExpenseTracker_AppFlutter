import 'package:flutter/material.dart';

import '../../models/add_expense_result.dart';
import '../../models/expense_model.dart';


import '../../services/expense_form_service.dart';

import '../../widgets/expense/add_category_dialog.dart';
import '../../widgets/expense/expense_category_selector.dart';
import '../../widgets/expense/expense_date_picker.dart';
import '../../widgets/expense/expense_form_fields.dart';
import '../../widgets/expense/recurring_expense_section.dart';


class AddExpenseScreen extends StatefulWidget {
  final Expense? expense;

  const AddExpenseScreen({
    super.key,
    this.expense,
  });

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();

  final _amountController = TextEditingController();



  DateTime _selectedDate = DateTime.now();

  String _selectedCategory = 'Food';

  final List<String> _categories = [
    'Food',
    'Transport',
    'Shopping',
    'Bills',
    'Entertainment',
    'Add Category',
  ];

  bool _isRecurring = false;

  String _recurringFrequency = 'monthly';

  DateTime? _recurringEndDate;

  @override
  @override
  void initState() {
    super.initState();

    final expense = widget.expense;

    if (expense == null) {
      return;
    }
    _titleController.text = expense.title;
    _amountController.text = expense.amount.toString();
    _selectedCategory = expense.category;
    _selectedDate = expense.date;

    if (!_categories.contains(_selectedCategory)) {
      _categories.insert(
        _categories.length - 1,
        _selectedCategory,
      );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  String capitalizeFirstLetter(String value) {
    if (value.isEmpty) return value;

    return value[0].toUpperCase() +
        value.substring(1);
  }

  Future<void> _saveExpense() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final result = ExpenseFormService.buildResult(
      title: _titleController.text,
      amountText: _amountController.text,
      category: _selectedCategory,
      date: _selectedDate,
      isRecurring: widget.expense == null
          ? _isRecurring
          : false,
      recurringFrequency: _recurringFrequency,
      recurringEndDate: _recurringEndDate,
      expenseId: widget.expense?.id,
    );

    if (result == null) {
      return;
    }

    Navigator.pop(context, result);
  }

  @override
  Widget build(BuildContext context) {
    final bool isEditing =
        widget.expense != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing
              ? 'Edit Expense'
              : 'Add Expense',
        ),
      ),

      body: SafeArea(
        child: Form(
          key: _formKey,

          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),

            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [

                ExpenseFormFields(
                  titleController: _titleController,
                  amountController: _amountController,
                ),

                const SizedBox(height: 16),

                // --------------------------------
                // DATE
                // --------------------------------
                ExpenseDatePicker(
                selectedDate: _selectedDate,
                onDateSelected: (date) {
                  setState(() {
                    _selectedDate = date;
                  });
                },
              ),

                const SizedBox(height: 20),

                // --------------------------------
                // CATEGORY
                // --------------------------------

                ExpenseCategorySelector(
                  categories: _categories,
                  selectedCategory: _selectedCategory,
                  onCategorySelected: (category) {
                    setState(() {
                      _selectedCategory = category;
                    });
                  },
                  onAddCategory: () async {
                    final category = await showAddCategoryDialog(context);

                    if (category == null || category.isEmpty) {
                      return;
                    }

                    setState(() {
                      if (!_categories.contains(category)) {
                        _categories.insert(
                          _categories.length - 1,
                          category,
                        );
                      }

                      _selectedCategory = category;
                    });
                  },
                ),

                // --------------------------------
                // RECURRING EXPENSE
                // --------------------------------

                if (!isEditing) ...[
                  const SizedBox(height: 20),

                  Card(
                    margin: EdgeInsets.zero,

                    child: SwitchListTile(
                      value: _isRecurring,

                      onChanged: (value) {
                        setState(() {
                          _isRecurring = value;

                          // Clear end date when
                          // recurring is disabled.
                          if (!value) {
                            _recurringEndDate =
                            null;
                          }
                        });
                      },

                      title: const Text(
                        'Make this a recurring expense',
                      ),

                      subtitle: const Text(
                        'Automatically add this expense again later',
                      ),

                      secondary: const Icon(
                        Icons.repeat,
                      ),
                    ),
                  ),

                  if (_isRecurring)
                    RecurringExpenseSection(
                      frequency: _recurringFrequency,
                      endDate: _recurringEndDate,
                      selectedDate: _selectedDate,

                      onFrequencyChanged: (frequency) {
                        setState(() {
                          _recurringFrequency = frequency;
                        });
                      },

                      onEndDateChanged: (date) {
                        setState(() {
                          _recurringEndDate = date;
                        });
                      },

                      onClearEndDate: () {
                        setState(() {
                          _recurringEndDate = null;
                        });
                      },
                    ),
                ],

                const SizedBox(height: 28),

                // --------------------------------
                // SAVE BUTTON
                // --------------------------------

                SizedBox(
                  width: double.infinity,

                  child: ElevatedButton(
                    onPressed: _saveExpense,

                    style: ElevatedButton.styleFrom(
                      padding:
                      const EdgeInsets.symmetric(
                        vertical: 15,
                      ),
                    ),

                    child: Text(
                      isEditing
                          ? 'Update Expense'
                          : 'Add Expense',
                    ),
                  ),
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}