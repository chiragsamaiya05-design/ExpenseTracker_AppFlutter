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

  Widget _buildCategoryChip(BuildContext context, String category,) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isSelected = selectedCategory == category;
    final isAddCategory = category == 'Add Category';

    if (isAddCategory) {
      return ActionChip(
        avatar: Icon(
          Icons.add_rounded,
          size: 18,
          color: colorScheme.primary,
        ),
        label: const Text('Add Category'),
        onPressed: onAddCategory,
        backgroundColor: colorScheme.primaryContainer.withValues(
          alpha: theme.brightness == Brightness.dark?0.35:0.65,
        ),
        side: BorderSide(
          color: colorScheme.primary.withValues(alpha: 0.4),
        ),
        labelStyle: TextStyle(
          color: colorScheme.primary,
          fontWeight: .w600,
        ),
      );
    }

    return ChoiceChip(
      selected: isSelected,
      avatar: Icon(
        _getCategoryIcon(category),
        size: 18,
        color: isSelected
        ? colorScheme.onPrimary
        :colorScheme.onSurfaceVariant,
      ),
      label: Text(category),
      onSelected: (_) {
        onCategorySelected(category);
      },
      backgroundColor: colorScheme.surfaceContainerLow,
      selectedColor: const Color(0xFF6557D9),
      side: BorderSide(
        color: isSelected
            ? const Color(0xFF6557D9)
            : colorScheme.outlineVariant,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      labelStyle: TextStyle(
        color: isSelected
            ? Colors.white
            : colorScheme.onSurface,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
      ),
      showCheckmark: false,
      materialTapTargetSize: MaterialTapTargetSize.padded,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category',
          style: theme.textTheme.titleMedium?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
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