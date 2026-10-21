import 'package:flutter/material.dart';

class ExpenseDatePicker extends StatelessWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  const ExpenseDatePicker({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  Future<void> _selectDate(BuildContext context) async {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: theme.copyWith(
            colorScheme: colorScheme.copyWith(
              primary: const Color(0xFF6557D9),
              onPrimary: Colors.white,
              surface: colorScheme.surface,
              onSurface: colorScheme.onSurface,
            ),
            datePickerTheme: DatePickerThemeData(
              backgroundColor: colorScheme.surface,
              headerBackgroundColor: colorScheme.primary,
              headerForegroundColor: colorScheme.onPrimary,
              todayForegroundColor: WidgetStatePropertyAll(
                colorScheme.primary,
              ),
              todayBorder: BorderSide(
                color: colorScheme.primary,
              ),
              dayForegroundColor: WidgetStateProperty.resolveWith(
                    (states) {
                  if (states.contains(WidgetState.selected)) {
                    return Colors.white;
                  }
                  return colorScheme.onSurface;
                },
              ),
              dayBackgroundColor: WidgetStateProperty.resolveWith(
                    (states) {
                  if (states.contains(WidgetState.selected)) {
                    return const Color(0xFF6557D9);
                  }
                  return null;
                },
              ),
              cancelButtonStyle: TextButton.styleFrom(
                foregroundColor: colorScheme.primary,
              ),
              confirmButtonStyle: TextButton.styleFrom(
                foregroundColor: colorScheme.primary,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate == null) return;

    onDateSelected(pickedDate);
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Date',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),

        const SizedBox(height: 8),

        Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () => _selectDate(context),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withValues(
                  alpha: theme.brightness == Brightness.dark ? 0.35 : 0.45,
                ),
                border: Border.all(
                  color: colorScheme.outlineVariant,
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_month_rounded,
                    color: colorScheme.primary,
                    size: 22,
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Text(
                      _formatDate(selectedDate),
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),

                  Icon(
                    Icons.keyboard_arrow_down_rounded,
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