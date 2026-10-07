import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
      case 'shopping':
        return Colors.purple;
      case 'bills':
        return Colors.green;
      case 'entertainment':
        return Colors.red;
      case 'health':
        return Colors.teal;
      case 'education':
        return Colors.indigo;
      case 'home':
        return Colors.brown;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Quick Add',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            TextButton(
              onPressed: () {
                // We'll connect this to all categories later.
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(0, 36),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text('More'),
            ),
          ],
        ),

        const SizedBox(height: 10),

        Row(
          children: List.generate(
            categories.length,
                (index) {
              final category = categories[index];
              final color = _getCategoryColor(category);

              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: index == categories.length - 1 ? 0 : 10,
                  ),
                  child: _QuickAddItem(
                    category: category,
                    icon: _getCategoryIcon(category),
                    color: color,
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

class _QuickAddItem extends StatelessWidget {
  final String category;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _QuickAddItem({
    required this.category,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.10),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 22,
              color: color,
            ),
          ),

          const SizedBox(height: 7),

          Text(
            category,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}