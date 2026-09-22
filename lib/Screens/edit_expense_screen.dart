import 'package:flutter/material.dart';

import '../constants/add_color.dart';
import '../models/expense_model.dart';


class EditExpenseScreen extends StatefulWidget {
  final Expense expense;

  const EditExpenseScreen({
    super.key,
    required this.expense,
  });

  @override
  State<EditExpenseScreen> createState() =>
      _EditExpenseScreenState();
}

class _EditExpenseScreenState
    extends State<EditExpenseScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController titleController;
  late TextEditingController amountController;

  late DateTime selectedDate;
  late String selectedCategory;

  final List<String> categories = [
    "Food",
    "Transport",
    "Shopping",
    "Bills",
    "Entertainment",
    "Add Category",
  ];

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController(
      text: widget.expense.title,
    );

    amountController = TextEditingController(
      text: widget.expense.amount.toString(),
    );

    selectedDate = widget.expense.date;
    selectedCategory = widget.expense.category;

    // If the existing expense has a custom category,
    // add it to the list.
    if (!categories.contains(selectedCategory) &&
        selectedCategory.isNotEmpty) {
      categories.insert(
        categories.length - 1,
        selectedCategory,
      );
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    amountController.dispose();
    super.dispose();
  }

  String capitalizeFirstLetter(String text) {
    final value = text.trim();

    if (value.isEmpty) {
      return value;
    }

    return value[0].toUpperCase() +
        value.substring(1);
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

  String formatDate(DateTime date) {
    const months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ];

    return "${date.day} ${months[date.month - 1]} ${date.year}";
  }

  Future<void> addCategory() async {
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
                final value = controller.text.trim();

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
          content: Text("Category already exists"),
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
  }

  Future<void> removeCategory(
      String category) async {
    final shouldDelete =
    await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Remove Category"),

          content: Text(
            'Remove "$category" category?',
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text("Cancel"),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
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
  }

  Future<void> selectDate() async {
    final DateTime? pickedDate =
    await showDatePicker(
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
  }

  void updateExpense() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (selectedCategory.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select a category"),
        ),
      );

      return;
    }

    final title =
    capitalizeFirstLetter(
      titleController.text,
    );

    final amount =
    double.parse(amountController.text);

    final updatedExpense = Expense(
      id: widget.expense.id,
      title: title,
      amount: amount,
      category: selectedCategory,
      date: selectedDate,
    );

    Navigator.pop(context, updatedExpense);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Expense"),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Form(
          key: _formKey,

          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [
              // -------------------------
              // TITLE
              // -------------------------

              TextFormField(
                controller: titleController,

                textCapitalization:
                TextCapitalization.sentences,

                decoration: InputDecoration(
                  labelText: "Expense Title",
                  hintText:
                  "e.g. Lunch, Bus fare, Shopping",

                  prefixIcon: const Icon(
                    Icons.edit_note_rounded,
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

                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return "Please enter an expense title";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              // -------------------------
              // AMOUNT
              // -------------------------

              TextFormField(
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
                  labelText: "Amount",
                  hintText: "0.00",

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

                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return "Please enter an amount";
                  }

                  final amount =
                  double.tryParse(value);

                  if (amount == null) {
                    return "Please enter a valid number";
                  }

                  if (amount <= 0) {
                    return "Amount must be greater than 0";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 20),

              // -------------------------
              // DATE
              // -------------------------

              InkWell(
                borderRadius:
                BorderRadius.circular(16),

                onTap: selectDate,

                child: Container(
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
                          Icons
                              .calendar_month_rounded,
                          size: 20,
                          color:
                          AppColors.primary,
                        ),
                      ),

                      const SizedBox(width: 14),

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment
                              .start,

                          children: [
                            Text(
                              "Date",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors
                                    .grey.shade600,
                              ),
                            ),

                            const SizedBox(height: 4),

                            Text(
                              formatDate(
                                selectedDate,
                              ),
                              style:
                              const TextStyle(
                                fontSize: 16,
                                fontWeight:
                                FontWeight.w600,
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

              const SizedBox(height: 24),

              // -------------------------
              // CATEGORY
              // -------------------------

              const Text(
                "Category",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              Wrap(
                spacing: 8,
                runSpacing: 8,

                children:
                categories.map((category) {
                  final isSelected =
                      selectedCategory ==
                          category;

                  final isCustomCategory =
                  ![
                    "Food",
                    "Transport",
                    "Shopping",
                    "Bills",
                    "Entertainment",
                    "Add Category",
                  ].contains(category);

                  // ADD CATEGORY
                  if (category ==
                      "Add Category") {
                    return ActionChip(
                      avatar: const Icon(
                        Icons.add_rounded,
                        size: 18,
                      ),

                      label: const Text(
                        "Add Category",
                      ),

                      onPressed: addCategory,

                      shape:
                      RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(
                          30,
                        ),
                      ),
                    );
                  }

                  // NORMAL CATEGORY
                  return Row(
                    mainAxisSize:
                    MainAxisSize.min,

                    children: [
                      ChoiceChip(
                        avatar: Icon(
                          getCategoryIcon(
                            category,
                          ),

                          size: 18,

                          color: isSelected
                              ? Colors.white
                              : Colors
                              .grey.shade700,
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
                              : Colors
                              .grey.shade300,
                        ),

                        shape:
                        RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(
                            30,
                          ),
                        ),

                        labelStyle:
                        TextStyle(
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
                              selectedCategory = "";
                            } else {
                              selectedCategory =
                                  category;
                            }
                          });
                        },
                      ),

                      if (isCustomCategory)
                        IconButton(
                          onPressed: () =>
                              removeCategory(
                                category,
                              ),

                          icon: const Icon(
                            Icons.close,
                            size: 16,
                          ),

                          padding: EdgeInsets.zero,

                          constraints:
                          const BoxConstraints(
                            minWidth: 24,
                            minHeight: 24,
                          ),
                        ),
                    ],
                  );
                }).toList(),
              ),

              const SizedBox(height: 30),

              // -------------------------
              // UPDATE BUTTON
              // -------------------------

              SizedBox(
                width: double.infinity,
                height: 52,

                child: ElevatedButton(
                  onPressed: updateExpense,

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
                    "Update Expense",

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
      ),
    );
  }
}