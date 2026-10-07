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
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: endDate ??
          selectedDate.add(
            const Duration(days: 30),
          ),
      firstDate: selectedDate,
      lastDate: DateTime(2100),
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
    return Column(
      children: [
        const SizedBox(height: 12),

        DropdownButtonFormField<String>(
          value: frequency,
          decoration: const InputDecoration(
            labelText: 'Repeat',
            prefixIcon: Icon(Icons.repeat),
            border: OutlineInputBorder(),
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

        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context)
                  .colorScheme
                  .outline,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            leading: const Icon(
              Icons.event_busy,
            ),
            title: const Text(
              'End date',
            ),
            subtitle: Text(
              endDate == null
                  ? 'No end date'
                  : _formatDate(endDate!),
            ),
            trailing: endDate != null
                ? IconButton(
              icon: const Icon(
                Icons.clear,
              ),
              onPressed: onClearEndDate,
            )
                : const Icon(
              Icons.chevron_right,
            ),
            onTap: () => _selectEndDate(context),
          ),
        ),
      ],
    );
  }
}