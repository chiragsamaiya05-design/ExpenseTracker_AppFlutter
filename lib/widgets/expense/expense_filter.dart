import 'package:flutter/material.dart';

class ExpenseFilter extends StatelessWidget {
  final String selectedSort;
  final ValueChanged<String?> onChanged;

  const ExpenseFilter({
    super.key,
    required this.selectedSort,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selectedSort,

      items: const [
        DropdownMenuItem(
          value: "Newest",
          child: Text("Newest"),
        ),
        DropdownMenuItem(
          value: "Oldest",
          child: Text("Oldest"),
        ),
        DropdownMenuItem(
          value: "Highest",
          child: Text("Highest Amount"),
        ),
        DropdownMenuItem(
          value: "Lowest",
          child: Text("Lowest Amount"),
        ),
      ],

      onChanged: onChanged,
    );
  }
}