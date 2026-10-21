import 'package:flutter/material.dart';

Future<String?> showAddCategoryDialog(
    BuildContext context,
    ) async {
  final controller = TextEditingController();

  final theme = Theme.of(context);
  final colorScheme = theme.colorScheme;

  final result = await showDialog<String>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(
            color: colorScheme.outlineVariant.withValues(
              alpha: 0.5,
            ),
          ),
        ),

        title: Text(
          'Add Category',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: colorScheme.onSurface,
          ),
        ),

        content: TextField(
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          cursorColor: colorScheme.primary,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurface,
          ),
          decoration: InputDecoration(
            labelText: 'Category name',
            hintText: 'e.g. Education',
            prefixIcon: Icon(
              Icons.category_outlined,
              color: colorScheme.primary,
            ),
            filled: true,
            fillColor: colorScheme.surfaceContainerHighest.withValues(
              alpha: theme.brightness == Brightness.dark ? 0.35 : 0.45,
            ),
            labelStyle: TextStyle(
              color: colorScheme.onSurfaceVariant,
            ),
            hintStyle: TextStyle(
              color: colorScheme.onSurfaceVariant.withValues(
                alpha: 0.7,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: colorScheme.outlineVariant,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: colorScheme.outlineVariant,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: colorScheme.primary,
                width: 2,
              ),
            ),
          ),
        ),

        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),

        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
            },
            style: TextButton.styleFrom(
              foregroundColor: colorScheme.onSurfaceVariant,
            ),
            child: const Text('Cancel'),
          ),

          FilledButton.icon(
            onPressed: () {
              final category = controller.text.trim();

              if (category.isEmpty) {
                return;
              }

              Navigator.pop(
                dialogContext,
                _capitalizeFirstLetter(category),
              );
            },
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF6557D9),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            icon: const Icon(Icons.add_rounded, size: 18),
            label: const Text('Add'),
          ),
        ],
      );
    },
  );

  controller.dispose();

  return result;
}

String _capitalizeFirstLetter(String value) {
  if (value.isEmpty) return value;

  return value[0].toUpperCase() + value.substring(1);
}