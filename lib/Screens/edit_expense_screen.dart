import 'package:flutter/material.dart';

import 'package:expense_tracker/models/expense_model.dart';

class EditExpenseScreen extends StatefulWidget{
  final Expense expense;

  const EditExpenseScreen({
    super.key,
  required this.expense
});
 @override
  State<EditExpenseScreen> createState()=> _EditExpenseScreenState();

}
class _EditExpenseScreenState extends State<EditExpenseScreen>{


  final titleController = TextEditingController();
  final amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final List<String> categories = [
    "Food",
    "Transport",
    "Shopping",
    "Bills",
    "Entertainment",
    "Add Category",
  ];
  late String selectedCategory;

  DateTime selectedDate = DateTime.now();

  @override
  void dispose(){
    titleController.dispose();
    amountController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    titleController.text = widget.expense.title;
    amountController.text = widget.expense.amount.toString();
    selectedCategory = widget.expense.category;
    selectedDate = widget.expense.date;

  }


  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Expense"),),
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
      onChanged: (value) {
        setState(() {
          selectedCategory = value!;
        });
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
  id: widget.expense!.id,
  title: title,
  amount: amount,
  category: selectedCategory,
  date: selectedDate,
  );
  Navigator.pop(context,expense);
  },
  child: const Text("Edit Expense"),),
  )

  ],
  ),
  ),
  ),
  );
  }


  }

