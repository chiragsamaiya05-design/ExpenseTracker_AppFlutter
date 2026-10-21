import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/expense_controller.dart';
import '../../widgets/expense/expense_list_item.dart';
import '../../widgets/expense/expense_filter_bottom_sheet.dart';
import '../../utils/confirmation_dailog.dart';
import 'edit_expense_screen.dart';

class AllExpensesScreen extends StatelessWidget {
  const AllExpensesScreen({super.key});

  static const Color _accentColor = Color(0xFF6557D9);

  void showFilterBottomSheet(BuildContext context) {
    final controller = context.read<ExpenseController>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      builder: (bottomSheetContext) {
        return ExpenseFilterBottomSheet(
          selectedCategory: controller.selectedCategory,
          selectedSort: controller.selectedSort,
          selectedDate: controller.selectedDate,
          onApply: (category, sort, date) {
            controller.setFilters(
              category,
              sort,
              date,
            );

            Navigator.pop(bottomSheetContext);
          },
          onClear: () {
            controller.setFilters(
              'All',
              'Newest',
              'All',
            );

            Navigator.pop(bottomSheetContext);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ExpenseController>();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          'All Expenses',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: colorScheme.onSurface,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Filter expenses',
            icon: const Icon(Icons.filter_list_rounded),
            color: colorScheme.primary,
            onPressed: () => showFilterBottomSheet(context),
          ),
          const SizedBox(width: 8),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(
            height: 1,
            thickness: 1,
            color: colorScheme.outlineVariant.withValues(alpha: 0.4),
          ),
        ),
      ),
      body: _buildBody(context, controller),
    );
  }

  Widget _buildBody(
      BuildContext context,
      ExpenseController controller,
      ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (controller.isLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: colorScheme.primary,
        ),
      );
    }

    if (controller.errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline_rounded,
                size: 44,
                color: colorScheme.error,
              ),
              const SizedBox(height: 12),
              Text(
                controller.errorMessage!,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: colorScheme.error,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (controller.allFilteredExpenses.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  color: _accentColor.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.receipt_long_rounded,
                  size: 42,
                  color: _accentColor,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'No expenses found',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Try changing your filters or add a new expense.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 12,
      ),
      itemCount: controller.allFilteredExpenses.length,
      itemBuilder: (context, index) {
        final expense = controller.allFilteredExpenses[index];

        return ExpenseListItem(
          expense: expense,
          onEdit: () async {
            final updatedExpense = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return EditExpenseScreen(
                    expense: expense,
                  );
                },
              ),
            );

            if (updatedExpense != null && context.mounted) {
              await context
                  .read<ExpenseController>()
                  .updateExpense(updatedExpense);
            }
          },
          onDelete: () async {
            final confirmed = await showConfirmationDialog(
              context,
              title: 'Delete Expense',
              message: 'Are you sure you want to delete this expense?',
            );

            if (confirmed && context.mounted) {
              await context
                  .read<ExpenseController>()
                  .deleteExpense(expense.id!);
            }
          },
        );
      },
    );
  }
}