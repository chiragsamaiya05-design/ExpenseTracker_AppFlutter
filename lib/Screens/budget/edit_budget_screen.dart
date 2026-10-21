import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/add_color.dart';
import '../../controllers/budget_controller.dart';
import '../../models/budget_model.dart';

class EditBudgetScreen extends StatefulWidget {
  final Budget budget;

  const EditBudgetScreen({
    super.key,
    required this.budget,
  });

  @override
  State<EditBudgetScreen> createState() => _EditBudgetScreenState();
}

class _EditBudgetScreenState extends State<EditBudgetScreen> {
  late TextEditingController amountController;

  late String selectedCategory;

  final List<String> categories = [
    'Food',
    'Transport',
    'Shopping',
    'Bills',
    'Entertainment',
    'Other',
  ];

  @override
  void initState() {
    super.initState();

    amountController = TextEditingController(
      text: widget.budget.amount.toString(),
    );

    selectedCategory = widget.budget.category;

    // If the existing budget has a category that isn't
    // in the default list, add it.
    if (!categories.contains(selectedCategory)) {
      categories.add(selectedCategory);
    }
  }

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
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

      case 'Other':
        return Icons.category_rounded;

      default:
        return Icons.category_rounded;
    }
  }

  String _monthName(String month) {
    final monthNumber = int.parse(month.split('-')[1]);

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

    return months[monthNumber - 1];
  }

  Future<void> updateBudget() async {
    final amount = double.tryParse(
      amountController.text.trim(),
    );

    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid budget amount'),
        ),
      );
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

    final controller = context.read<BudgetController>();

    final updatedBudget = Budget(
      id: widget.budget.id,
      category: selectedCategory,
      amount: amount,
      month: widget.budget.month,
    );

    await controller.updateBudget(updatedBudget);

    if (!mounted) return;

    Navigator.pop(context, updatedBudget);
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<BudgetController>();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Edit Budget',
          style: theme.textTheme.titleLarge?.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // CATEGORY
              Text(
                'Budget Category',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),

              const SizedBox(height: 12),

              Wrap(
                spacing: 8,
                runSpacing: 8,

                children: categories.map((category) {
                  final isSelected =
                      selectedCategory == category;

                  return ChoiceChip(
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          getCategoryIcon(category),
                          size: 18,
                          color: isSelected
                              ? Colors.white
                              : colorScheme.onSurfaceVariant,
                        ),

                        const SizedBox(width: 7),

                        Text(category),
                      ],
                    ),

                    selected: isSelected,

                    onSelected: (selected) {
                      setState(() {
                        selectedCategory = selected
                            ? category
                            : '';
                      });
                    },

                    selectedColor: const Color(0xFF6557D9),
                    backgroundColor: colorScheme.surface,

                    side: BorderSide(
                      color: isSelected
                          ? const Color(0xFF6557D9)
                          : colorScheme.outlineVariant,
                    ),

                    labelStyle: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : colorScheme.onSurface,
                      fontWeight: FontWeight.w500,
                    ),

                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 8,
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 28),

              // AMOUNT
               Text(
                'Budget Amount',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
              ),

              const SizedBox(height: 12),

              TextField(
                controller: amountController,

                keyboardType:
                const TextInputType.numberWithOptions(
                  decimal: true,
                ),

                style: theme.textTheme.titleLarge?.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),

                decoration: InputDecoration(
                  hintText: 'Enter budget amount',

                  prefixIcon: Icon(
                    Icons.currency_rupee_rounded,
                    color: colorScheme.primary,
                  ),

                  filled: true,
                  fillColor: colorScheme.surfaceContainerHighest
                      .withValues(alpha: 0.35),

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
                      color: colorScheme.outlineVariant,
                    ),
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color: Color(0xFF6557D9),
                      width: 2,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // MONTH
               Text(
                'Budget Month',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),

              const SizedBox(height: 12),

              Container(
                width: double.infinity,

                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),

                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: colorScheme.outlineVariant,
                  ),
                ),

                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(7),

                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(9),
                      ),

                      child: const Icon(
                        Icons.calendar_month_rounded,
                        size: 20,
                        color: AppColors.primary,
                      ),
                    ),

                    const SizedBox(width: 14),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,

                        children: [
                          Text(
                            'Month',
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontSize: 12,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),

                          const SizedBox(height: 4),

                          Text(
                            _monthName(widget.budget.month),
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 36),

              // UPDATE BUTTON
              SizedBox(
                width: double.infinity,
                height: 52,

                child: ElevatedButton(
                  onPressed:
                  controller.isLoading
                      ? null
                      : updateBudget,

                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6557D9),
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: colorScheme.surfaceContainerHighest,
                    disabledForegroundColor: colorScheme.onSurfaceVariant,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),

                  child: controller.isLoading
                      ? const SizedBox(
                    height: 22,
                    width: 22,
                    child:
                    CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : const Text(
                    'Update Budget',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight:
                      FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}