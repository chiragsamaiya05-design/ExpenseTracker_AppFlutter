import 'package:flutter/material.dart';

class ExpenseFilterBottomSheet extends StatefulWidget {
  final String selectedCategory;
  final String selectedSort;
  final String selectedDate;

  final Function(String category, String sort, String date) onApply;
  final VoidCallback onClear;

  const ExpenseFilterBottomSheet({
    super.key,
    required this.selectedCategory,
    required this.selectedSort,
    required this.selectedDate,
    required this.onApply,
    required this.onClear,
  });

  @override
  State<ExpenseFilterBottomSheet> createState() =>
      _ExpenseFilterBottomSheetState();
}

class _ExpenseFilterBottomSheetState
    extends State<ExpenseFilterBottomSheet> {
  static const Color _accentColor = Color(0xFF6557D9);

  late String tempCategory;
  late String tempSort;
  late String tempDate;

  @override
  void initState() {
    super.initState();

    tempCategory = widget.selectedCategory;
    tempSort = widget.selectedSort;
    tempDate = widget.selectedDate;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 12,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 42,
                height: 5,
                decoration: BoxDecoration(
                  color: colorScheme.onSurfaceVariant.withValues(
                    alpha: 0.35,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Header
            Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: _accentColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.filter_list_rounded,
                    color: _accentColor,
                    size: 25,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Filter Expenses',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Customize your expense list',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            _buildSectionLabel(
              context,
              'Category',
              Icons.category_outlined,
            ),
            const SizedBox(height: 10),

            _buildDropdown(
              context: context,
              value: tempCategory,
              items: const [
                DropdownMenuItem(value: 'All', child: Text('All Categories')),
                DropdownMenuItem(value: 'Food', child: Text('Food')),
                DropdownMenuItem(
                  value: 'Transport',
                  child: Text('Transport'),
                ),
                DropdownMenuItem(
                  value: 'Shopping',
                  child: Text('Shopping'),
                ),
                DropdownMenuItem(value: 'Bills', child: Text('Bills')),
              ],
              onChanged: (value) {
                if (value == null) return;

                setState(() {
                  tempCategory = value;
                });
              },
            ),

            const SizedBox(height: 22),

            _buildSectionLabel(
              context,
              'Sort By',
              Icons.sort_rounded,
            ),
            const SizedBox(height: 10),

            _buildDropdown(
              context: context,
              value: tempSort,
              items: const [
                DropdownMenuItem(
                  value: 'Newest',
                  child: Text('Newest First'),
                ),
                DropdownMenuItem(
                  value: 'Oldest',
                  child: Text('Oldest First'),
                ),
                DropdownMenuItem(
                  value: 'Low',
                  child: Text('Amount: Low to High'),
                ),
                DropdownMenuItem(
                  value: 'High',
                  child: Text('Amount: High to Low'),
                ),
              ],
              onChanged: (value) {
                if (value == null) return;

                setState(() {
                  tempSort = value;
                });
              },
            ),

            const SizedBox(height: 22),

            _buildSectionLabel(
              context,
              'Date',
              Icons.calendar_month_outlined,
            ),
            const SizedBox(height: 10),

            _buildDropdown(
              context: context,
              value: tempDate,
              items: const [
                DropdownMenuItem(value: 'All', child: Text('All Dates')),
                DropdownMenuItem(value: 'Today', child: Text('Today')),
                DropdownMenuItem(value: 'Month', child: Text('This Month')),
              ],
              onChanged: (value) {
                if (value == null) return;

                setState(() {
                  tempDate = value;
                });
              },
            ),

            const SizedBox(height: 28),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      widget.onClear();
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: colorScheme.onSurface,
                      side: BorderSide(
                        color: colorScheme.outline.withValues(alpha: 0.6),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'Clear',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onApply(
                        tempCategory,
                        tempSort,
                        tempDate,
                      );

                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _accentColor,
                      foregroundColor: Colors.white,
                      elevation: isDark ? 0 : 1,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'Apply Filters',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionLabel(
      BuildContext context,
      String label,
      IconData icon,
      ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        Icon(
          icon,
          size: 19,
          color: colorScheme.primary,
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required BuildContext context,
    required String value,
    required List<DropdownMenuItem<String>> items,
    required ValueChanged<String?> onChanged,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Prevent DropdownButton from receiving a value that isn't in its items.
    final validValue = items.any((item) => item.value == value)
        ? value
        : items.first.value!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark
            ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.35)
            : colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.7),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: validValue,
          isExpanded: true,
          items: items,
          onChanged: onChanged,
          dropdownColor: colorScheme.surface,
          borderRadius: BorderRadius.circular(14),
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: colorScheme.onSurfaceVariant,
          ),
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}