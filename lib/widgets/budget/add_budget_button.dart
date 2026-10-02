import 'package:flutter/material.dart';

class AddBudgetButton extends StatelessWidget {
  const AddBudgetButton({
    super.key,
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: const Icon(
          Icons.add_rounded,
          size: 20,
        ),
        label: const Text(
          'Add Category Budget',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFFF1E2),
          foregroundColor: const Color(0xFFF2994A),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          side: BorderSide(
            color: const Color(0xFFF2994A).withOpacity(0.25),
          ),
        ),
      ),
    );
  }
}