import 'package:flutter/material.dart';

import '../constants/add_color.dart';

import '../controllers/expense_controller.dart';

class AddIncomeScreen extends StatefulWidget {
  final ExpenseController controller;

  const AddIncomeScreen({
    super.key,
    required this.controller,
  });

  @override
  State<AddIncomeScreen> createState() => _AddIncomeScreenState();
}

class _AddIncomeScreenState extends State<AddIncomeScreen> {
  late TextEditingController incomeController;

  String? errorMessage;

  @override
  void initState() {
    super.initState();

    incomeController = TextEditingController(
      text: widget.controller.monthlyIncome > 0
          ? widget.controller.monthlyIncome.toStringAsFixed(2)
          : '',
    );
  }

  @override
  void dispose() {
    incomeController.dispose();
    super.dispose();
  }

  Future<void> saveIncome() async {
    final income = double.tryParse(
      incomeController.text.trim(),
    );

    if (income == null) {
      setState(() {
        errorMessage = 'Please enter your income';
      });
      return;
    }

    if (income <= 0) {
      setState(() {
        errorMessage = 'Income must be greater than ₹0';
      });
      return;
    }

    setState(() {
      errorMessage = null;
    });

    await widget.controller.saveIncome(income);

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 12,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Header
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.account_balance_wallet_rounded,
                  color: AppColors.primary,
                ),
              ),

              const SizedBox(width: 12),

              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Monthly Income',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  SizedBox(height: 3),

                  Text(
                    'Set your income for this month',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Amount label
          const Text(
            'Income Amount',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 8),

          // Amount field
          TextField(
            controller: incomeController,
            autofocus: true,
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
            ),
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
            decoration: InputDecoration(
              prefixText: '₹ ',
              prefixStyle: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
              hintText: '0.00',
              hintStyle: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 22,
              ),
              filled: true,
              fillColor: AppColors.background,
              errorText: errorMessage,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 2,
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Save button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: saveIncome,
              icon: const Icon(
                Icons.check_rounded,
              ),
              label: const Text(
                'Save Income',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}