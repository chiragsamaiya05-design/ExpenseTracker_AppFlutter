import 'package:flutter/material.dart';

class ExpenseCategorySelector extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;
  final VoidCallback onAddCategory;

  const ExpenseCategorySelector({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
    required this.onAddCategory,
  });

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Food':
        return Icons.restaurant;

      case 'Transport':
        return Icons.directions_car;

      case 'Shopping':
        return Icons.shopping_bag;

      case 'Bills':
        return Icons.receipt_long;

      case 'Entertainment':
        return Icons.movie;

      default:
        return Icons.category;
    }
  }

  Widget _buildCategoryChip(
      BuildContext context,
      String category,
      ) {
    final isSelected = selectedCategory == category;

    if (category == 'Add Category') {
      return ActionChip(
        avatar: const Icon(
          Icons.add,
          size: 18,
        ),
        label: const Text('Add Category'),
        onPressed: onAddCategory,
      );
    }

    return ChoiceChip(
      selected: isSelected,
      avatar: Icon(
        _getCategoryIcon(category),
        size: 18,
      ),
      label: Text(category),
      onSelected: (_) {
        onCategorySelected(category);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category',
          style: Theme.of(context).textTheme.titleMedium,
        ),

        const SizedBox(height: 10),

        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: categories
              .map(
                (category) => _buildCategoryChip(
              context,
              category,
            ),
          )
              .toList(),
        ),
      ],
    );
  }
}