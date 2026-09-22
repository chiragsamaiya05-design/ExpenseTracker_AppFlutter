import 'package:flutter/material.dart';

import 'package:expense_tracker/models/expense_model.dart';
import 'package:expense_tracker/database/expenses_DataBase.dart';

import '../widgets/add_text_form_Field.dart';

class AddExpenseScreen  extends StatefulWidget{
  final Expense? expense;

  const AddExpenseScreen({
    super.key,
    this.expense,
});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState ();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {

  final titleController = TextEditingController();
  final amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  DateTime selectedDate = DateTime.now();
  final List<String> categories = [
    "Food",
    "Transport",
    "Shopping",
    "Bills",
    "Entertainment",
    "Add Category",
  ];
  String selectedCategory = "";

  String capitalizeFirstLetter(String text) {
    final value = text.trim();

    if (value.isEmpty) {
      return value;
    }

    return value[0].toUpperCase() + value.substring(1);
  }

  IconData getCategoryIcon(String category) {
    switch (category) {
      case "Food":
        return Icons.restaurant_rounded;

      case "Transport":
        return Icons.directions_car_rounded;

      case "Shopping":
        return Icons.shopping_bag_rounded;

      case "Bills":
        return Icons.receipt_long_rounded;

      case "Entertainment":
        return Icons.movie_rounded;

      case "Add Category":
        return Icons.add_rounded;

      default:
        return Icons.category_rounded;
    }
  }

  @override
  void dispose(){
    titleController.dispose();
    amountController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    if (widget.expense != null) {
      titleController.text = widget.expense!.title;
      amountController.text = widget.expense!.amount.toString();
      selectedCategory = widget.expense!.category;
      selectedDate = widget.expense!.date;
    }
  }


  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Expense"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Form(
          key: _formKey,
          child: Padding(
              padding: EdgeInsetsGeometry.all(8),
            child: Column(
              children: [
        
                const Text(
                    "Tilte",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        
                const SizedBox(height: 8,),

                AppTextFormField(
                  controller: titleController,
                  label: "Expense Title",
                  hint: "e.g. Lunch, Bus fare, Shopping",
                  icon: Icons.edit_note_rounded,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter an expense title";
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 20),
        
                const Text(
                  "Amount",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8,),

                AppTextFormField(
                  controller: amountController,
                  label: "Amount",
                  hint: "0.00",
                  icon: Icons.currency_rupee_rounded,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter an amount";
                    }

                    final amount = double.tryParse(value);

                    if (amount == null || amount <= 0) {
                      return "Enter a valid amount";
                    }

                    return null;
                  },
                ),
        
                const SizedBox(height: 20),
                const Text(
                  "Date",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        
                const SizedBox(height: 8),

                InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () async {
                    final DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                    );

                    if (pickedDate != null) {
                      setState(() {
                        selectedDate = pickedDate;
                      });
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.grey.shade200,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Icon(
                            Icons.calendar_month_rounded,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),

                        const SizedBox(width: 14),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Date",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),

                              const SizedBox(height: 4),

                              Text(
                                "${selectedDate.day}/"
                                    "${selectedDate.month}/"
                                    "${selectedDate.year}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),

                        Icon(
                          Icons.chevron_right_rounded,
                          color: Colors.grey.shade500,
                        ),
                      ],
                    ),
                  ),
                ),
        
                const SizedBox(height: 30),
        
                const Text(
                  "Category",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        
        
                const SizedBox(height: 8),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Categories",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: categories.map((category) {
                        final bool isSelected =
                            selectedCategory == category;

                        final bool isCustomCategory = ![
                          "Food",
                          "Transport",
                          "Shopping",
                          "Bills",
                          "Entertainment",
                          "Add Category",
                        ].contains(category);

                        // Add Category chip
                        if (category == "Add Category") {
                          return ActionChip(
                            avatar: const Icon(
                              Icons.add_rounded,
                              size: 18,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            label: const Text("Add Category"),
                            onPressed: () async {
                              final newCategory = await showDialog<String>(
                                context: context,
                                builder: (dialogContext) {
                                  final controller = TextEditingController();

                                  return AlertDialog(
                                    title: const Text("Add Category"),
                                    content: TextField(
                                      controller: controller,
                                      autofocus: true,
                                      textCapitalization:
                                      TextCapitalization.words,
                                      decoration: const InputDecoration(
                                        hintText: "Enter category name",
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(dialogContext);
                                        },
                                        child: const Text("Cancel"),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          final value =
                                          controller.text.trim();

                                          if (value.isNotEmpty) {
                                            Navigator.pop(
                                              dialogContext,
                                              capitalizeFirstLetter(value),
                                            );
                                          }
                                        },
                                        child: const Text("Add"),
                                      ),
                                    ],
                                  );
                                },
                              );

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
                                    content: Text(
                                      "Category already exists",
                                    ),
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
                            },
                          );
                        }

                        // Normal + custom category
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ChoiceChip(
                              avatar: Icon(
                                getCategoryIcon(category),
                                size: 18,
                                color: isSelected
                                    ? Colors.white
                                    : Colors.grey.shade700,
                              ),
                              label: Text(category),
                              selected: isSelected,
                              selectedColor: Theme.of(context).colorScheme.primary,
                              backgroundColor: Colors.white,
                              side: BorderSide(
                                color: isSelected
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.grey.shade300,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
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
                                  if (selectedCategory == category) {
                                    selectedCategory = "";
                                  } else {
                                    selectedCategory = category;
                                  }
                                });
                              },
                            ),

                            // Delete button only for custom categories
                            if (isCustomCategory)
                              IconButton(
                                onPressed: () async {
                                  final shouldDelete =
                                  await showDialog<bool>(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text(
                                          "Remove Category",
                                        ),
                                        content: Text(
                                          'Remove "$category" category?',
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(
                                                context,
                                                false,
                                              );
                                            },
                                            child: const Text("Cancel"),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.pop(
                                                context,
                                                true,
                                              );
                                            },
                                            child: const Text("Remove"),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                  if (shouldDelete == true && mounted) {
                                    setState(() {
                                      categories.remove(category);

                                      if (selectedCategory == category) {
                                        selectedCategory = "";
                                      }
                                    });
                                  }
                                },
                                icon: const Icon(
                                  Icons.close,
                                  size: 16,
                                ),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(
                                  minWidth: 24,
                                  minHeight: 24,
                                ),
                              ),
                          ],
                        );
                      }).toList(),
                    )
                  ],
                ),
              const SizedBox(height: 30,),
        
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(

                    onPressed: () async {

                    if (!_formKey.currentState!.validate()){
                      return;
                    }
                    final String title =
                    capitalizeFirstLetter(titleController.text);
                    final amount = double.parse(amountController.text);
                    final expense = Expense(
                      id: null,
                      title: title,
                      amount: amount,
                      category: selectedCategory,
                      date: selectedDate,
                    );
                    Navigator.pop(context,expense);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4F46A5),
                      foregroundColor: Colors.white,
                      elevation: 0,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),),),
                    child:  Text("Add Expense",),
                  ),
                )
        
              ],
            ),
          ),
        ),
      ),
    );
  }


}