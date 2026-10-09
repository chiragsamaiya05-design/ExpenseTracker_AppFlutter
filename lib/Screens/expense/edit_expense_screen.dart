import 'package:flutter/material.dart';

import '../../models/expense_model.dart';

class EditExpenseScreen extends StatefulWidget {
  final Expense expense;

  const EditExpenseScreen({
    super.key,
    required this.expense,
  });

  @override
  State<EditExpenseScreen> createState() =>
      _EditExpenseScreenState();
}

class _EditExpenseScreenState
    extends State<EditExpenseScreen> {
  static const Color _accentColor = Color(0xFF6557D9);

  final _formKey = GlobalKey<FormState>();

  late TextEditingController titleController;
  late TextEditingController amountController;

  late DateTime selectedDate;
  late String selectedCategory;

  final List<String> categories = [
    'Food',
    'Transport',
    'Shopping',
    'Bills',
    'Entertainment',
    'Add Category',
  ];

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController(
      text: widget.expense.title,
    );

    amountController = TextEditingController(
      text: widget.expense.amount.toString(),
    );

    selectedDate = widget.expense.date;
    selectedCategory = widget.expense.category;

    // Preserve an existing custom category.
    if (!categories.contains(selectedCategory) &&
        selectedCategory.isNotEmpty) {
      categories.insert(
        categories.length - 1,
        selectedCategory,
      );
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    amountController.dispose();
    super.dispose();
  }

  String capitalizeFirstLetter(String text) {
    final value = text.trim();

    if (value.isEmpty) {
      return value;
    }

    return value[0].toUpperCase() +
        value.substring(1);
  }

  IconData getCategoryIcon(String category) {
    switch (category) {
      case 'Food':
        return Icons.restaurant_rounded;
      case 'Transport':
        return Icons.directions_car_rounded;
      case 'Shopping':
        return Icons.shopping_bag_rounded;
      case 'Bills':
        return Icons.receipt_long_rounded;
      case 'Entertainment':
        return Icons.movie_rounded;
      case 'Add Category':
        return Icons.add_rounded;
      default:
        return Icons.category_rounded;
    }
  }

  String formatDate(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  Future<void> addCategory() async {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final controller = TextEditingController();

    final newCategory = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: colorScheme.surface,
          title: Text(
            'Add Category',
            style: theme.textTheme.titleLarge?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: TextField(
            controller: controller,
            autofocus: true,
            textCapitalization: TextCapitalization.words,
            cursorColor: colorScheme.primary,
            style: TextStyle(
              color: colorScheme.onSurface,
            ),
            decoration: InputDecoration(
              hintText: 'Enter category name',
              filled: true,
              fillColor: colorScheme.surfaceContainerHighest
                  .withValues(alpha: 0.4),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: colorScheme.outlineVariant,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: colorScheme.primary,
                  width: 2,
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: _accentColor,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                final value = controller.text.trim();

                if (value.isNotEmpty) {
                  Navigator.pop(
                    dialogContext,
                    capitalizeFirstLetter(value),
                  );
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );

    controller.dispose();

    if (!mounted ||
        newCategory == null ||
        newCategory.isEmpty) {
      return;
    }

    final alreadyExists = categories.any(
          (item) =>
      item.toLowerCase() ==
          newCategory.toLowerCase(),
    );

    if (alreadyExists) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Category already exists'),
        ),
      );
      return;
    }

    setState(() {
      categories.insert(
        categories.length - 1,
        newCategory,
      );

      selectedCategory = newCategory;
    });
  }

  Future<void> removeCategory(String category) async {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: colorScheme.surface,
          title: Text(
            'Remove Category',
            style: theme.textTheme.titleLarge?.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
          content: Text(
            'Remove "$category" category?',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: colorScheme.error,
                foregroundColor: colorScheme.onError,
              ),
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Remove'),
            ),
          ],
        );
      },
    );

    if (shouldDelete == true && mounted) {
      setState(() {
        categories.remove(category);

        if (selectedCategory == category) {
          selectedCategory = '';
        }
      });
    }
  }

  Future<void> selectDate() async {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: theme.copyWith(
            colorScheme: colorScheme.copyWith(
              primary: _accentColor,
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null && mounted) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  void updateExpense() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (selectedCategory.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a category'),
        ),
      );
      return;
    }

    final title = capitalizeFirstLetter(
      titleController.text,
    );

    final amount = double.parse(
      amountController.text,
    );

    final updatedExpense = Expense(
      id: widget.expense.id,
      title: title,
      amount: amount,
      category: selectedCategory,
      date: selectedDate,
    );

    Navigator.pop(context, updatedExpense);
  }

  InputDecoration _inputDecoration({
    required BuildContext context,
    required String label,
    required String hint,
    required IconData icon,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(
        icon,
        color: colorScheme.onSurfaceVariant,
      ),
      filled: true,
      fillColor: colorScheme.surfaceContainerHighest
          .withValues(alpha: isDark ? 0.35 : 0.45),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 18,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: colorScheme.outlineVariant.withValues(
            alpha: isDark ? 0.5 : 0.7,
          ),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: _accentColor,
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: colorScheme.error,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: colorScheme.error,
          width: 2,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Edit Expense',
          style: theme.textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // EXPENSE TITLE
                TextFormField(
                  controller: titleController,
                  textCapitalization:
                  TextCapitalization.sentences,
                  cursorColor: colorScheme.primary,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                  decoration: _inputDecoration(
                    context: context,
                    label: 'Expense Title',
                    hint: 'e.g. Lunch, Bus fare, Shopping',
                    icon: Icons.edit_note_rounded,
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return 'Please enter an expense title';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // AMOUNT
                TextFormField(
                  controller: amountController,
                  keyboardType:
                  const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  cursorColor: colorScheme.primary,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: _inputDecoration(
                    context: context,
                    label: 'Amount',
                    hint: '0.00',
                    icon: Icons.currency_rupee_rounded,
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return 'Please enter an amount';
                    }

                    final amount = double.tryParse(
                      value.trim(),
                    );

                    if (amount == null) {
                      return 'Please enter a valid number';
                    }

                    if (amount <= 0) {
                      return 'Amount must be greater than 0';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // DATE SELECTOR
                InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: selectDate,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: colorScheme.outlineVariant
                            .withValues(
                          alpha: isDark ? 0.5 : 0.7,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(9),
                          decoration: BoxDecoration(
                            color: _accentColor.withValues(
                              alpha: isDark ? 0.22 : 0.12,
                            ),
                            borderRadius:
                            BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.calendar_month_rounded,
                            size: 21,
                            color: _accentColor,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Date',
                                style: theme.textTheme.bodySmall
                                    ?.copyWith(
                                  color: colorScheme
                                      .onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                formatDate(selectedDate),
                                style: theme.textTheme.titleMedium
                                    ?.copyWith(
                                  color: colorScheme.onSurface,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.chevron_right_rounded,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // CATEGORY HEADING
                Text(
                  'Category',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 12),

                // CATEGORY SELECTOR
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: categories.map((category) {
                    final isSelected =
                        selectedCategory == category;

                    final isCustomCategory = ![
                      'Food',
                      'Transport',
                      'Shopping',
                      'Bills',
                      'Entertainment',
                      'Add Category',
                    ].contains(category);

                    if (category == 'Add Category') {
                      return ActionChip(
                        avatar: const Icon(
                          Icons.add_rounded,
                          size: 18,
                          color: _accentColor,
                        ),
                        label: const Text(
                          'Add Category',
                          style: TextStyle(
                            color: _accentColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        backgroundColor: _accentColor.withValues(
                          alpha: isDark ? 0.18 : 0.09,
                        ),
                        side: BorderSide(
                          color: _accentColor.withValues(
                            alpha: 0.45,
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(30),
                        ),
                        onPressed: addCategory,
                      );
                    }

                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ChoiceChip(
                          avatar: Icon(
                            getCategoryIcon(category),
                            size: 18,
                            color: isSelected
                                ? Colors.white
                                : colorScheme.onSurfaceVariant,
                          ),
                          label: Text(category),
                          selected: isSelected,
                          selectedColor: _accentColor,
                          backgroundColor:
                          colorScheme.surfaceContainerLow,
                          side: BorderSide(
                            color: isSelected
                                ? _accentColor
                                : colorScheme.outlineVariant,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(30),
                          ),
                          labelStyle: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : colorScheme.onSurface,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                          onSelected: (selected) {
                            setState(() {
                              selectedCategory = selected
                                  ? category
                                  : '';
                            });
                          },
                        ),
                        if (isCustomCategory)
                          IconButton(
                            tooltip: 'Remove $category',
                            onPressed: () {
                              removeCategory(category);
                            },
                            icon: Icon(
                              Icons.close_rounded,
                              size: 16,
                              color: colorScheme.onSurfaceVariant,
                            ),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(
                              minWidth: 28,
                              minHeight: 28,
                            ),
                          ),
                      ],
                    );
                  }).toList(),
                ),

                const SizedBox(height: 30),

                // UPDATE BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: updateExpense,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _accentColor,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Update Expense',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}