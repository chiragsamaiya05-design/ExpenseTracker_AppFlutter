import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/add_color.dart';
import '../controllers/budget_controller.dart';
import '../models/budget_model.dart';

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

    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: const Text(
          'Edit Budget',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // CATEGORY
              const Text(
                'Budget Category',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
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
                              : AppColors.textSecondary,
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

                    selectedColor: AppColors.primary,

                    backgroundColor: Colors.white,

                    labelStyle: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : AppColors.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      side: BorderSide(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.border,
                      ),
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
              const Text(
                'Budget Amount',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 12),

              TextField(
                controller: amountController,

                keyboardType:
                const TextInputType.numberWithOptions(
                  decimal: true,
                ),

                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),

                decoration: InputDecoration(
                  hintText: 'Enter budget amount',

                  prefixIcon: const Icon(
                    Icons.currency_rupee_rounded,
                  ),

                  filled: true,
                  fillColor: Colors.white,

                  contentPadding:
                  const EdgeInsets.symmetric(
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
                      color: AppColors.border,
                    ),
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 2,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // MONTH
              const Text(
                'Budget Month',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
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
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.border,
                  ),
                ),

                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(7),

                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius:
                        BorderRadius.circular(9),
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
                          const Text(
                            'Month',
                            style: TextStyle(
                              fontSize: 12,
                              color:
                              AppColors.textSecondary,
                            ),
                          ),

                          const SizedBox(height: 4),

                          Text(
                            _monthName(widget.budget.month),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight:
                              FontWeight.w600,
                              color:
                              AppColors.textPrimary,
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
                    backgroundColor:
                    AppColors.primary,

                    foregroundColor: Colors.white,

                    elevation: 0,

                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(16),
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