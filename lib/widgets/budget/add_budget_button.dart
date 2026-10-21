import 'package:flutter/material.dart';

class AddBudgetButton extends StatelessWidget {
  const AddBudgetButton({
    super.key,
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    const accentColor = Color(0xFFF2994A);

    const primaryColor = Color(0xFF6557D9);

    final isDark = theme.brightness == Brightness.dark;

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
          backgroundColor: isDark
              ? colorScheme.surfaceContainer
              : const Color(0xFFF0EDFF),
          foregroundColor: isDark
              ? colorScheme.primary
              : primaryColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          side: BorderSide(
            color: isDark
                ? colorScheme.outlineVariant
                : primaryColor.withValues(alpha: 0.25),
          ),
        ),
      ),
    );
  }
}