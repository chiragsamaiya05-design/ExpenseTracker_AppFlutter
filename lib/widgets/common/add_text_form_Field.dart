import 'package:flutter/material.dart';

class AppTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final TextStyle? style;

  const AppTextFormField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.keyboardType,
    this.validator,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final borderRadius = BorderRadius.circular(16);

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: style ??
          theme.textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurface,
          ),
      cursorColor: colorScheme.primary,

      decoration: InputDecoration(
        labelText: label,
        hintText: hint,

        labelStyle: TextStyle(
          color: colorScheme.onSurfaceVariant,
        ),
        floatingLabelStyle: TextStyle(
          color: colorScheme.primary,
          fontWeight: FontWeight.w500,
        ),
        hintStyle: TextStyle(
          color: colorScheme.onSurfaceVariant.withValues(
            alpha: 0.7,
          ),
        ),

        prefixIcon: Icon(
          icon,
          color: colorScheme.onSurfaceVariant,
        ),

        filled: true,
        fillColor: colorScheme.surfaceContainerHighest.withValues(
          alpha: isDark ? 0.35 : 0.45,
        ),

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),

        border: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide.none,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(
            color: colorScheme.outlineVariant.withValues(
              alpha: isDark ? 0.5 : 0.7,
            ),
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: 2,
          ),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(
            color: colorScheme.error,
          ),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(
            color: colorScheme.error,
            width: 2,
          ),
        ),
      ),

      validator: validator,
    );
  }
}