import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/expense_model.dart';

import 'add_expense_screen.dart';
import 'edit_expense_screen.dart';
import 'summary_screen.dart';
import 'all_expenses_screen.dart';
import 'budget_screen.dart';

import 'package:expense_tracker/widgets/balance_card.dart';
import 'package:expense_tracker/widgets/income_expense_card.dart';
import 'package:expense_tracker/widgets/expense_list_item.dart';
import 'package:expense_tracker/widgets/home_app_bar.dart';
import 'add_income_screen.dart';

import 'package:expense_tracker/utils/confirmation_dailog.dart';

import 'package:expense_tracker/controllers/expense_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{


  final TextEditingController searchController = TextEditingController();
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    loadData();
  }
  Future<void> loadData() async {
    final controller = context.read<ExpenseController>();

    await controller.loadExpenses();
    await controller.loadIncome();
  }
  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

   return Scaffold(
     appBar:  HomeAppBar(
     isSearching: isSearching,
     searchController: searchController,

     onSearchChanged: (value) {
       context.read<ExpenseController>().setSearchText(value);
     },

     onSearch: () {
       setState(() {
         isSearching = true;
       });
     },

     onCloseSearch: () {
       setState(() {
         isSearching = false;

         searchController.clear();
       });
       context.read<ExpenseController>().setSearchText("");
     },

     onSummary: () {
       Navigator.push(
         context,
         MaterialPageRoute(
           builder: (context) => const SummaryScreen(),
         ),
       );
     },
   ),

     body: Consumer<ExpenseController>(
       builder: (context,controller,chlid) {
         return Padding(
           padding: EdgeInsetsGeometry.all(16),
           child: Column(
               crossAxisAlignment: .start,
               children: <Widget>[
                 BalanceCard(
                   balance: controller.totalBalance,
                 ),

                 const SizedBox(height: 10,),

                 Row(
                   children: [
                     IncomeExpenseCard(
                       title: "Income",
                       amount: controller.monthlyIncome,
                       onTap: () async {
                         await showModalBottomSheet(
                           context: context,
                           isScrollControlled: true,
                           builder: (context) {
                             return AddIncomeScreen(
                               controller: controller,
                             );
                           },
                         );
                       },
                     ),

                     const SizedBox(width: 10),

                     IncomeExpenseCard(
                       title: "Expense",
                       amount: controller.totalExpense,
                     ),
                   ],
                 ),
                 const SizedBox(height: 16),

                 ElevatedButton.icon(
                   onPressed: () {
                     Navigator.push(
                       context,
                       MaterialPageRoute(
                         builder: (context) => const BudgetScreen(),
                       ),
                     );
                   },
                   icon: const Icon(Icons.account_balance_wallet),
                   label: const Text('Manage Budget'),
                 ),

                 const SizedBox(height: 10,),

                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     const Text(
                       "Recent Transactions",
                       style: TextStyle(
                         fontSize: 20,
                         fontWeight: FontWeight.bold,
                       ),
                     ),
                     TextButton(
                       onPressed: () {
                         Navigator.push(
                           context,
                           MaterialPageRoute(
                             builder: (context) => const AllExpensesScreen(),
                           ),
                         );
                       },
                       child: const Text("View All"),
                     ),
                   ],
                 ),
                 const SizedBox(height: 10,),

                 Expanded(
                   child: ListView.builder(
                     itemCount: controller.displayExpenses.length,
                     itemBuilder: (context, index) {
                       final expense = controller.displayExpenses[index];

                       return ExpenseListItem(
                         expense: expense,

                         onEdit: () async {
                           final Expense? updatedExpense = await Navigator.push(
                             context,
                             MaterialPageRoute(
                               builder: (context) =>
                                   EditExpenseScreen(
                                     expense: expense,
                                   ),
                             ),
                           );
                           if (updatedExpense != null) {
                             await controller.updateExpense(updatedExpense);
                           }
                         },

                         onDelete: () async {
                           final confirmed = await showConfirmationDialog(
                             context,
                             title: "Delete Expense",
                             message: "Are you sure you want to delete this expense?",
                           );

                           if (confirmed) {
                             await controller.deleteExpense(expense.id!);
                           }
                         },
                       );
                     },
                   ),
                 ),
               ]
           ),
         );
       }
     ),

     floatingActionButton: FloatingActionButton(
       onPressed: () async{
         final Expense? newExpense = await Navigator.push(
           context,
           MaterialPageRoute(
             builder: (context) => const AddExpenseScreen(),
           ),
         );
         if (newExpense != null) {
           await context
               .read<ExpenseController>()
               .addExpense(newExpense);

         }
       },
       child: const Icon(Icons.add),
     ),
   );
  }
}