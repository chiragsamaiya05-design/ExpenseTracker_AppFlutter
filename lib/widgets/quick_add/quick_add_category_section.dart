import 'package:flutter/material.dart';
import '../../widgets/expense/expense_category_selector.dart';

class QuickAddCategorySection extends StatelessWidget {
  final List<String> categories;
  final void Function(String category) onCategoryTap;

  const QuickAddCategorySection({
    super.key,
    required this.categories,
    required this.onCategoryTap,
  });

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return Icons.restaurant_rounded;

      case 'transport':
        return Icons.directions_bus_rounded;

      case 'shopping':
        return Icons.shopping_bag_rounded;

      case 'bills':
        return Icons.receipt_long_rounded;

      case 'entertainment':
        return Icons.movie_rounded;

      case 'health':
        return Icons.medical_services_rounded;

      case 'education':
        return Icons.school_rounded;

      case 'home':
        return Icons.home_rounded;

      default:
        return Icons.category_rounded;
    }
  }
  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return Colors.orange;

        case 'transport':
          return Colors.blue;
        case 'shopping': return Colors.purple; case 'bills': return Colors.green; case 'entertainment': return Colors.red; case 'health': return Colors.teal; case 'education': return Colors.indigo; case 'home': return Colors.brown; default: return Colors.grey; } }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    if (categories.isEmpty) { return const SizedBox.shrink(); }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Add',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: 12),

        Row(
          children: List.generate(categories.length,(index)  {
            final category = categories[index];
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: _CategoryItem(
                  category: category,
                  icon: _getCategoryIcon(category),
                  color: _getCategoryColor(category),
                  onTap: () => onCategoryTap(category),
                ),
              ),
            );
          },
          ),
        ),
      ],
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final String category;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _CategoryItem({
    required this.category,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 18,
              color: color,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            category,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ],
      ),
    );
  }
}