import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/add_color.dart';
import '../controllers/budget_controller.dart';
import '../models/budget_model.dart';

class AddBudgetScreen extends StatefulWidget {
  const AddBudgetScreen({super.key});

  @override
  State<AddBudgetScreen> createState() =>
      _AddBudgetScreenState();
}

class _AddBudgetScreenState extends State<AddBudgetScreen> {
  final _amountController = TextEditingController();
  DateTime currentMonth = DateTime.now();

  String selectedCategory = '';

  final List<String> categories = [
    'Food',
    'Transport',
    'Shopping',
    'Bills',
    'Entertainment',
    'Other',
  ];

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  // -------------------------
  // CATEGORY ICON
  // -------------------------

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

  // -------------------------
  // SAVE BUDGET
  // -------------------------

  Future<void> saveBudget() async {
    final amount =
    double.tryParse(_amountController.text.trim());

    if (selectedCategory.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please select a category',
          ),
        ),
      );
      return;
    }

    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Enter a valid budget amount',
          ),
        ),
      );
      return;
    }

    final controller =
    context.read<BudgetController>();

    final budget = Budget(
      category: selectedCategory,
      amount: amount,
      month: controller.currentMonth,
    );

    await controller.addBudget(budget);

    if (!mounted) return;

    Navigator.pop(context);
  }
  String _monthName(int month) {
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

    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Budget'),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [
            // -------------------------
            // CATEGORY
            // -------------------------

            const Text(
              'Category',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Wrap(
              spacing: 8,
              runSpacing: 8,

              children: categories.map(
                    (category) {
                  final bool isSelected =
                      selectedCategory ==
                          category;

                  return ChoiceChip(
                    avatar: Icon(
                      getCategoryIcon(category),
                      size: 18,
                      color: isSelected
                          ? Colors.white
                          : Colors.grey.shade700,
                    ),

                    label: Text(category),

                    selected: isSelected,

                    selectedColor:
                    AppColors.primary,

                    backgroundColor:
                    Colors.white,

                    side: BorderSide(
                      color: isSelected
                          ? AppColors.primary
                          : Colors.grey.shade300,
                    ),

                    shape:
                    RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(30),
                    ),

                    labelStyle: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : Colors.grey.shade800,

                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),

                    onSelected: (selected) {
                      setState(() {
                        if (selectedCategory ==
                            category) {
                          selectedCategory = '';
                        } else {
                          selectedCategory =
                              category;
                        }
                      });
                    },
                  );
                },
              ).toList(),
            ),

            const SizedBox(height: 24),

            // -------------------------
            // BUDGET AMOUNT
            // -------------------------

            TextField(
              controller: _amountController,

              keyboardType:
              const TextInputType.numberWithOptions(
                decimal: true,
              ),

              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),

              decoration: InputDecoration(
                labelText: 'Budget Amount',
                hintText: '0.00',

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
                  borderRadius:
                  BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),

                enabledBorder:
                OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: Colors.grey.shade200,
                  ),
                ),

                focusedBorder:
                OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: AppColors.primary,
                    width: 2,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // -------------------------
            // MONTH
            // -------------------------

            Container(
              width: double.infinity,

              padding:
              const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),

              decoration: BoxDecoration(
                color: Colors.white,

                borderRadius:
                BorderRadius.circular(16),

                border: Border.all(
                  color: Colors.grey.shade200,
                ),
              ),

              child: Row(
                children: [
                  Container(
                    padding:
                    const EdgeInsets.all(7),

                    decoration: BoxDecoration(
                      color: AppColors.primary
                          .withOpacity(0.1),

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
                        Text(
                          'Budget Month',
                          style: TextStyle(
                            fontSize: 12,
                            color:
                            Colors.grey.shade600,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          _monthName(
                            int.parse(
                              context.read<BudgetController>().currentMonth.split('-')[1],
                            ),
                          ),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // -------------------------
            // SAVE BUTTON
            // -------------------------

            SizedBox(
              width: double.infinity,
              height: 52,

              child: ElevatedButton(
                onPressed: saveBudget,

                style:
                ElevatedButton.styleFrom(
                  backgroundColor:
                  AppColors.primary,

                  foregroundColor:
                  Colors.white,

                  elevation: 0,

                  shape:
                  RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(16),
                  ),
                ),

                child: const Text(
                  'Save Budget',

                  style: TextStyle(
                    fontSize: 16,
                    fontWeight:
                    FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // -------------------------
  // MONTH NAME
  // -------------------------


}