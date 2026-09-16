import 'package:flutter/material.dart';

class CategoryFilter extends StatelessWidget {
  final String selectedCategory;
  final ValueChanged<String?> onChanged;

  const CategoryFilter({
    super.key,
    required this.selectedCategory,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selectedCategory,

      items: const [
        DropdownMenuItem(
          value: "All",
          child: Text("All Categories"),
        ),
        DropdownMenuItem(
          value: "Food",
          child: Text("Food"),
        ),
        DropdownMenuItem(
          value: "Travel",
          child: Text("Travel"),
        ),
        DropdownMenuItem(
          value: "Shopping",
          child: Text("Shopping"),
        ),
        DropdownMenuItem(
          value: "Bills",
          child: Text("Bills"),
        ),
        DropdownMenuItem(
          value: "Other",
          child: Text("Other"),
        ),
      ],

      onChanged: onChanged,
    );
  }
}