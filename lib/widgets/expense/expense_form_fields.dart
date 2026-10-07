import 'package:flutter/material.dart';

import '../common/add_text_form_Field.dart';

class ExpenseFormFields extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController amountController;

  const ExpenseFormFields({
    super.key,
    required this.titleController,
    required this.amountController,
  });

  String? _validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter expense title';
    }

    return null;
  }

  String? _validateAmount(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter amount';
    }

    final amount = double.tryParse(value.trim());

    if (amount == null) {
      return 'Enter a valid amount';
    }

    if (amount <= 0) {
      return 'Amount must be greater than 0';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppTextFormField(
          controller: titleController,
          label: 'Expense Title',
          hint: 'Enter expense title',
          icon: Icons.description_outlined,
          validator: _validateTitle,
        ),

        const SizedBox(height: 16),

        AppTextFormField(
          controller: amountController,
          label: 'Amount',
          hint: 'Enter amount',
          icon: Icons.currency_rupee,
          keyboardType: const TextInputType.numberWithOptions(
            decimal: true,
          ),
          validator: _validateAmount,
        ),
      ],
    );
  }
}