
import 'package:flutter/material.dart';

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

@override
void initState() {
super.initState();

incomeController = TextEditingController(
text: widget.controller.monthlyIncome.toString(),
);
}

@override
void dispose() {
incomeController.dispose();
super.dispose();
}

Future<void> saveIncome() async {
final income = double.tryParse(incomeController.text);

if (income == null || income < 0) {
return;
}

await widget.controller.saveIncome(income);

if (mounted) {
Navigator.pop(context);
}
}

@override
Widget build(BuildContext context) {
return Padding(
padding: EdgeInsets.only(
left: 16,
right: 16,
top: 20,
bottom: MediaQuery.of(context).viewInsets.bottom + 20,
),
child: Column(
mainAxisSize: MainAxisSize.min,
children: [
const Text(
"ADD Monthly Income",
style: TextStyle(
fontSize: 20,
fontWeight: FontWeight.bold,
),
),

const SizedBox(height: 20),

TextField(
controller: incomeController,
keyboardType: TextInputType.number,
decoration: const InputDecoration(
labelText: "Enter your income",
border: OutlineInputBorder(),
),
),

const SizedBox(height: 20),

SizedBox(
width: double.infinity,
child: ElevatedButton(
onPressed: saveIncome,
child: const Text("Save"),
),
),
],
),
);
}
}

