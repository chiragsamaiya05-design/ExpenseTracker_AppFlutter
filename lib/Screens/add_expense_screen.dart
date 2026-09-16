import 'package:flutter/material.dart';

import 'package:expense_tracker/models/expense_model.dart';
import 'package:expense_tracker/database/expenses_DataBase.dart';

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
  String selectedCategory = "Food";

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
      body: Form(
        key: _formKey,
        child: Padding(
            padding: EdgeInsetsGeometry.all(16),
          child: Column(
            children: [

              const Text("Tilte"),

              const SizedBox(height: 8,),

              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  hintText: "Enter expense tilte",
                  border: OutlineInputBorder(),
                ),
                validator: (value){
                  if (value== null || value.trim().isEmpty){
                    return "Please enter a title";
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

              TextFormField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: "Enter amount",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter an amount";
                  }

                  final amount = double.tryParse(value);

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
              const Text(
                "Date",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                  side: const BorderSide(),
                ),

                title: Text(
                  "${selectedDate.day}/"
                      "${selectedDate.month}/"
                      "${selectedDate.year}",
                ),

                trailing: const Icon(Icons.calendar_month),

                onTap: () async {
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
                },
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

              DropdownButtonFormField<String>(
                value: selectedCategory,
                decoration: const InputDecoration(
                  labelText: "Category",
                  border: OutlineInputBorder(),
                ),
                items: categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),

                onChanged: (value) async {
                  if (value == "Add Category") {
                    final controller = TextEditingController();

                    final newCategory = await showDialog<String>(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Add Category"),
                          content: TextField(
                            controller: controller,
                            decoration: const InputDecoration(
                              hintText: "Enter category name",
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("Cancel"),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                final category = controller.text.trim();

                                if (category.isNotEmpty) {
                                  Navigator.pop(context, category);
                                }
                              },
                              child: const Text("Add"),
                            ),
                          ],
                        );
                      },
                    );

                    if (newCategory != null) {
                      setState(() {
                        categories.insert(categories.length - 1, newCategory);
                        selectedCategory = newCategory;
                      });
                    }
                  } else {
                    setState(() {
                      selectedCategory = value!;
                    });
                  }
                },
              ),
            const SizedBox(height: 30,),

              SizedBox(
                width: double.infinity,

                child: ElevatedButton(onPressed: () async {
                  if (!_formKey.currentState!.validate()){
                    return;
                  }
                  final String title = titleController.text.trim();
                  final  amount = double.parse(amountController.text);
                  final expense = Expense(
                    id: null,
                    title: title,
                    amount: amount,
                    category: selectedCategory,
                    date: selectedDate,
                  );
                  Navigator.pop(context,expense);
                  },
                  child: const Text("Add Expense"),),
              )

            ],
          ),
        ),
      ),
    );
  }


}