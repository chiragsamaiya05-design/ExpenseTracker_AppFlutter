import 'package:flutter/material.dart';

class AddDailyBudgetCard extends StatefulWidget {
  const AddDailyBudgetCard({
    super.key,
    required this.currentBudget,
    required this.isLoading,
    required this.onSave,
  });

  final double currentBudget;
  final bool isLoading;
  final Future<void> Function(double amount) onSave;

  @override
  State<AddDailyBudgetCard> createState() =>
      _AddDailyBudgetCardState();
}

class _AddDailyBudgetCardState
    extends State<AddDailyBudgetCard> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController(
      text: widget.currentBudget > 0
          ? widget.currentBudget.toStringAsFixed(0)
          : '',
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _saveBudget() async {
    final amount = double.tryParse(
      _controller.text.trim(),
    );

    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter a valid budget amount',
          ),
        ),
      );
      return;
    }

    await widget.onSave(amount);

    if (!mounted) return;

    FocusScope.of(context).unfocus();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Daily budget saved'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text(
              'Set Daily Budget',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              'Set how much you want to spend today.',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: _controller,
              keyboardType:
              const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                prefixText: '₹ ',
                hintText: '500',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                widget.isLoading ? null : _saveBudget,
                child: widget.isLoading
                    ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                )
                    : const Text('Set Budget'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}