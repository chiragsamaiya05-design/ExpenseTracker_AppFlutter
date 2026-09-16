import 'package:flutter/material.dart';

class ExpenseFilterBottomSheet extends StatefulWidget {
  final String selectedCategory;
  final String selectedSort;
  final String selectedDate;

  final Function(String category, String sort, String date) onApply;
  final VoidCallback onClear;

  const ExpenseFilterBottomSheet({
    super.key,
    required this.selectedCategory,
    required this.selectedSort,
    required this.selectedDate,
    required this.onApply,
    required this.onClear,
  });

  @override
  State<ExpenseFilterBottomSheet> createState() =>
      _ExpenseFilterBottomSheetState();
}

class _ExpenseFilterBottomSheetState
    extends State<ExpenseFilterBottomSheet> {

  late String tempCategory;
  late String tempSort;
  late String tempDate;

  @override
  void initState() {
    super.initState();

    tempCategory = widget.selectedCategory;
    tempSort = widget.selectedSort;
    tempDate = widget.selectedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),

      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          const Text(
            "Filter Expenses",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          const Text("Category"),

          DropdownButton<String>(
            value: tempCategory,
            isExpanded: true,

            items: const [
              DropdownMenuItem(
                value: "All",
                child: Text("All"),
              ),
              DropdownMenuItem(
                value: "Food",
                child: Text("Food"),
              ),
              DropdownMenuItem(
                value: "Transport",
                child: Text("Transport"),
              ),
              DropdownMenuItem(
                value: "Shopping",
                child: Text("Shopping"),
              ),
              DropdownMenuItem(
                value: "Bills",
                child: Text("Bills"),
              ),
            ],

            onChanged: (value) {
              if (value == null) return;

              setState(() {
                tempCategory = value;
              });
            },
          ),

          const SizedBox(height: 10),

          const Text("Sort By"),

          DropdownButton<String>(
            value: tempSort,
            isExpanded: true,

            items: const [
              DropdownMenuItem(
                value: "Newest",
                child: Text("Newest First"),
              ),
              DropdownMenuItem(
                value: "Oldest",
                child: Text("Oldest First"),
              ),
              DropdownMenuItem(
                value: "Low",
                child: Text("Amount: Low to High"),
              ),
              DropdownMenuItem(
                value: "High",
                child: Text("Amount: High to Low"),
              ),
            ],

            onChanged: (value) {
              if (value == null) return;

              setState(() {
                tempSort = value;
              });
            },
          ),

          const SizedBox(height: 10),

          const Text("Date"),

          DropdownButton<String>(
            value: tempDate,
            isExpanded: true,

            items: const [
              DropdownMenuItem(
                value: "All",
                child: Text("All Dates"),
              ),
              DropdownMenuItem(
                value: "Today",
                child: Text("Today"),
              ),
              DropdownMenuItem(
                value: "Month",
                child: Text("This Month"),
              ),
            ],

            onChanged: (value) {
              if (value == null) return;

              setState(() {
                tempDate = value;
              });
            },
          ),

          const SizedBox(height: 20),

          Row(
            children: [

              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    widget.onClear();
                    Navigator.pop(context);
                  },
                  child: const Text("Clear"),
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    widget.onApply(
                      tempCategory,
                      tempSort,
                      tempDate,
                    );

                    Navigator.pop(context);
                  },
                  child: const Text("Apply"),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),
        ],
      ),
    );
  }
}