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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          isEditing ? 'Edit Expense' : 'Add Expense',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        backgroundColor: theme.scaffoldBackgroundColor,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: colorScheme.outlineVariant.withValues(
              alpha: isDark ? 0.35 : 0.5,
            ),
          ),
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
                    color: colorScheme.surfaceContainerLow,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: colorScheme.outlineVariant.withValues(
                          alpha: isDark ? 0.35 : 0.5,
                        ),
                      ),
                    ),
                    child: SwitchListTile(
                      value: _isRecurring,
                      activeThumbColor: colorScheme.primary,
                      activeTrackColor: colorScheme.primary.withValues(
                        alpha: 0.35,
                      ),
                      onChanged: (value) {
                        setState(() {
                          _isRecurring = value;

                          if (!value) {
                            _recurringEndDate = null;
                          }
                        });
                      },
                      title: Text(
                        'Make this a recurring expense',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      subtitle: Text(
                        'Automatically add this expense again later',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      secondary: Icon(
                        Icons.repeat_rounded,
                        color: colorScheme.primary,
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
                      backgroundColor: const Color(0xFF6557D9),
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: colorScheme.surfaceContainerHighest,
                      disabledForegroundColor: colorScheme.onSurfaceVariant,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      isEditing ? 'Update Expense' : 'Add Expense',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
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