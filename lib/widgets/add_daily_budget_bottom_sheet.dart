import 'package:flutter/material.dart';

class AddDailyBudgetBottomSheet extends StatefulWidget {
  const AddDailyBudgetBottomSheet({
    super.key,
    required this.currentBudget,
    required this.isLoading,
    required this.onSave,
  });

  final double currentBudget;
  final bool isLoading;
  final Future<void> Function(double amount) onSave;

  @override
  State<AddDailyBudgetBottomSheet> createState() =>
      _AddDailyBudgetBottomSheetState();
}

class _AddDailyBudgetBottomSheetState
    extends State<AddDailyBudgetBottomSheet> {

  late final TextEditingController _amountController;

  @override
  void initState() {
    super.initState();

    _amountController = TextEditingController(
      text: widget.currentBudget > 0
          ? widget.currentBudget.toStringAsFixed(0)
          : '',
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final amount = double.tryParse(
      _amountController.text.trim(),
    );

    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter a valid amount'),
        ),
      );
      return;
    }

    await widget.onSave(amount);

    if (!mounted) return;

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
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

            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Set Daily Budget',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              'Set your spending limit for today.',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: _amountController,
              autofocus: true,
              keyboardType:
              const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                prefixText: '₹ ',
                hintText: '500',
                labelText: 'Daily Budget',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed:
                widget.isLoading ? null : _save,
                child: widget.isLoading
                    ? const SizedBox(
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                )
                    : const Text(
                  'Save Daily Budget',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}