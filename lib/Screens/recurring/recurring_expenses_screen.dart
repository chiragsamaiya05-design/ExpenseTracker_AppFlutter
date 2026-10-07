import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/recurring_expense_controller.dart';
import '../../models/recurring_expense_model.dart';
import 'add_recurring_expense_screen.dart';

class RecurringExpensesScreen extends StatefulWidget {
  const RecurringExpensesScreen({super.key});

  @override
  State<RecurringExpensesScreen> createState() =>
      _RecurringExpensesScreenState();
}

class _RecurringExpensesScreenState
    extends State<RecurringExpensesScreen> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context
          .read<RecurringExpenseController>()
          .loadRecurringExpenses();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recurring Expenses'),
      ),

      body: Consumer<RecurringExpenseController>(
        builder: (context, controller, child) {

          if (controller.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (controller.errorMessage != null) {
            return _buildError(
              context,
              controller,
            );
          }

          if (controller.recurringExpenses.isEmpty) {
            return _buildEmptyState(context);
          }

          return RefreshIndicator(
            onRefresh: controller.loadRecurringExpenses,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [

                _buildHeader(controller),

                const SizedBox(height: 16),

                ...controller.recurringExpenses.map(
                      (expense) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _RecurringExpenseCard(
                      expense: expense,
                      onToggle: () {
                        controller.toggleActive(expense);
                      },
                      onDelete: () {
                        _deleteExpense(
                          context,
                          controller,
                          expense,
                        );
                      },
                      onEdit: () {
                        // We'll connect this next.
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
              const AddRecurringExpenseScreen(),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add'),
      ),
    );
  }

  // --------------------------------------------------
  // Header
  // --------------------------------------------------

  Widget _buildHeader(
      RecurringExpenseController controller,
      ) {
    final activeCount =
        controller.activeRecurringExpenses.length;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [

          Icon(
            Icons.repeat,
            size: 32,
            color: Theme.of(context)
                .colorScheme
                .onPrimaryContainer,
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [

                const Text(
                  'Recurring Expenses',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  '$activeCount active recurring '
                      'expense${activeCount == 1 ? '' : 's'}',
                  style: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .onPrimaryContainer
                        .withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------
  // Empty State
  // --------------------------------------------------

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [

            Icon(
              Icons.repeat,
              size: 70,
              color: Theme.of(context)
                  .colorScheme
                  .primary
                  .withValues(alpha: 0.5),
            ),

            const SizedBox(height: 20),

            const Text(
              'No recurring expenses',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Add expenses that repeat regularly '
                  'like rent, subscriptions or gym fees.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context)
                    .colorScheme
                    .onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 24),

            FilledButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                    const AddRecurringExpenseScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text(
                'Add Recurring Expense',
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --------------------------------------------------
  // Error
  // --------------------------------------------------

  Widget _buildError(
      BuildContext context,
      RecurringExpenseController controller,
      ) {
    return Center(
      child: Column(
        mainAxisAlignment:
        MainAxisAlignment.center,
        children: [

          const Icon(
            Icons.error_outline,
            size: 50,
          ),

          const SizedBox(height: 12),

          Text(
            controller.errorMessage!,
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 16),

          FilledButton(
            onPressed:
            controller.loadRecurringExpenses,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------
  // Delete
  // --------------------------------------------------

  Future<void> _deleteExpense(
      BuildContext context,
      RecurringExpenseController controller,
      RecurringExpense expense,
      ) async {

    final shouldDelete =
    await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Delete recurring expense?',
          ),
          content: Text(
            'This will stop "${expense.title}" '
                'from recurring.',
          ),
          actions: [

            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  false,
                );
              },
              child: const Text('Cancel'),
            ),

            FilledButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  true,
                );
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true) return;

    await controller.deleteRecurringExpense(
      expense.id!,
    );
  }
}

// ==================================================
// RECURRING EXPENSE CARD
// ==================================================

class _RecurringExpenseCard extends StatelessWidget {

  final RecurringExpense expense;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const _RecurringExpenseCard({
    required this.expense,
    required this.onToggle,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [

            // Category icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: theme
                    .colorScheme
                    .primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getCategoryIcon(
                  expense.category,
                ),
                color: theme
                    .colorScheme
                    .onPrimaryContainer,
              ),
            ),

            const SizedBox(width: 12),

            // Details
            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [

                  Text(
                    expense.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    expense.category,
                    style: TextStyle(
                      color: theme
                          .colorScheme
                          .onSurfaceVariant,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    '${_capitalize(expense.frequency)} • '
                        'Next: ${_formatDate(expense.nextDueDate)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: theme
                          .colorScheme
                          .onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // Amount + menu
            Column(
              crossAxisAlignment:
              CrossAxisAlignment.end,
              children: [

                Text(
                  '₹${expense.amount.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                PopupMenuButton<String>(
                  icon: const Icon(
                    Icons.more_vert,
                  ),
                  onSelected: (value) {

                    if (value == 'toggle') {
                      onToggle();
                    }

                    if (value == 'edit') {
                      onEdit();
                    }

                    if (value == 'delete') {
                      onDelete();
                    }
                  },
                  itemBuilder: (context) => [

                    PopupMenuItem(
                      value: 'toggle',
                      child: Text(
                        expense.isActive
                            ? 'Pause'
                            : 'Resume',
                      ),
                    ),

                    const PopupMenuItem(
                      value: 'edit',
                      child: Text('Edit'),
                    ),

                    const PopupMenuItem(
                      value: 'delete',
                      child: Text('Delete'),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return Icons.restaurant;

      case 'travel':
        return Icons.directions_car;

      case 'grocery':
        return Icons.shopping_cart;

      case 'health':
        return Icons.medical_services;

      case 'gym':
        return Icons.fitness_center;

      case 'entertainment':
        return Icons.movie;

      case 'bills':
        return Icons.receipt_long;

      default:
        return Icons.category;
    }
  }

  String _capitalize(String value) {
    if (value.isEmpty) return value;

    return value[0].toUpperCase() +
        value.substring(1);
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }
}