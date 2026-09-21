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
import 'package:expense_tracker/controllers/budget_controller.dart';

import '../widgets/monthly_settlement_listener.dart';

class HomeScreen extends StatelessWidget {
   HomeScreen({super.key});

   @override
  Widget build(BuildContext context) {
    final controller = context.watch<ExpenseController>();
    final recentExpenses = controller.displayExpenses.take(3).toList();

   return MonthlySettlementListener(
     child: Scaffold(
       appBar:  HomeAppBar(
       isSearching: controller.isSearching,
     
     
         onSearchChanged: (value) {
         controller.setSearchText(value);
         },
         onSearch: () {
         controller.startSearch();
         },
         onCloseSearch: () {
     
         controller.closeSearch();
         },
         onSummary: () {
         Navigator.push(
           context,
           MaterialPageRoute(
             builder: (context) => const SummaryScreen(),
           ),
         );
         },
         onReset: () async {
           final confirmed = await showConfirmationDialog(
             context,
             title: 'Reset All Data',
             message:
             'Are you sure you want to delete all expenses, income and budgets?',
           );
           if (!confirmed) return;
     
           final expenseController = context.read<ExpenseController>();
           final budgetController = context.read<BudgetController>();
     
           await expenseController.resetAllData();
           await budgetController.loadBudgetData();
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
     
                   SizedBox(
                     height: 250,
                     child: ListView.builder(
                       itemCount: recentExpenses.length,
                       itemBuilder: (context, index) {
                         final expense = recentExpenses[index];
     
                         return ExpenseListItem(
                           expense: expense,
     
                           onEdit: () async {
                             final Expense? updatedExpense = await Navigator.push(
                               context,
                               MaterialPageRoute(
                                 builder: (context) => EditExpenseScreen(
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
     ),
   );
  }
}