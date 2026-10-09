import 'package:flutter/material.dart';

class RecurringExpenseSection extends StatelessWidget {
  final String frequency;
  final DateTime? endDate;
  final ValueChanged<String> onFrequencyChanged;
  final ValueChanged<DateTime> onEndDateChanged;
  final VoidCallback onClearEndDate;
  final DateTime selectedDate;

  const RecurringExpenseSection({
    super.key,
    required this.frequency,
    required this.endDate,
    required this.onFrequencyChanged,
    required this.onEndDateChanged,
    required this.onClearEndDate,
    required this.selectedDate,
  });

  Future<void> _selectEndDate(BuildContext context) async {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: endDate ??
          selectedDate.add(const Duration(days: 30)),
      firstDate: selectedDate,
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: theme.copyWith(
            colorScheme: colorScheme.copyWith(
              primary: const Color(0xFF6557D9),
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate == null) return;

    onEndDateChanged(pickedDate);
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final borderRadius = BorderRadius.circular(14);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),

        // Repeat frequency
        DropdownButtonFormField<String>(
          initialValue: frequency,
          isExpanded: true,
          dropdownColor: colorScheme.surface,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurface,
          ),
          iconEnabledColor: colorScheme.onSurfaceVariant,
          decoration: InputDecoration(
            labelText: 'Repeat',
            prefixIcon: Icon(
              Icons.repeat_rounded,
              color: colorScheme.primary,
            ),
            filled: true,
            fillColor: colorScheme.surfaceContainerHighest.withValues(
              alpha: isDark ? 0.35 : 0.45,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: borderRadius,
              borderSide: BorderSide(
                color: colorScheme.outlineVariant,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: borderRadius,
              borderSide: BorderSide(
                color: colorScheme.outlineVariant,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: borderRadius,
              borderSide: BorderSide(
                color: colorScheme.primary,
                width: 2,
              ),
            ),
          ),
          items: const [
            DropdownMenuItem(
              value: 'daily',
              child: Text('Daily'),
            ),
            DropdownMenuItem(
              value: 'weekly',
              child: Text('Weekly'),
            ),
            DropdownMenuItem(
              value: 'monthly',
              child: Text('Monthly'),
            ),
            DropdownMenuItem(
              value: 'yearly',
              child: Text('Yearly'),
            ),
          ],
          onChanged: (value) {
            if (value == null) return;
            onFrequencyChanged(value);
          },
        ),

        const SizedBox(height: 12),

        // End date
        Material(
          color: colorScheme.surfaceContainerLow,
          borderRadius: borderRadius,
          child: InkWell(
            borderRadius: borderRadius,
            onTap: () => _selectEndDate(context),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                borderRadius: borderRadius,
                border: Border.all(
                  color: colorScheme.outlineVariant.withValues(
                    alpha: isDark ? 0.5 : 0.7,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.event_rounded,
                      color: colorScheme.primary,
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'End date',
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          endDate == null
                              ? 'No end date'
                              : _formatDate(endDate!),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),

                  if (endDate != null)
                    IconButton(
                      tooltip: 'Clear end date',
                      onPressed: onClearEndDate,
                      icon: Icon(
                        Icons.close_rounded,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    )
                  else
                    Icon(
                      Icons.chevron_right_rounded,
                      color: colorScheme.onSurfaceVariant,
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}