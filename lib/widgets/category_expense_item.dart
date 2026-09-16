import 'package:flutter/material.dart';

class CategoryExpenseItem extends StatelessWidget {
  final String category;
  final double amount;

  const CategoryExpenseItem({
    super.key,
    required this.category,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(category),
      trailing: Text(
        amount.toStringAsFixed(2),
      ),
    );
  }
}