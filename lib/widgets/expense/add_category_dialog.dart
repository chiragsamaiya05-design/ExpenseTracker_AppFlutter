import 'package:flutter/material.dart';

Future<String?> showAddCategoryDialog(
    BuildContext context,
    ) async {
  final controller = TextEditingController();

  final result = await showDialog<String>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Add Category'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Category name',
            hintText: 'e.g. Education',
            border: OutlineInputBorder(),
          ),
          textCapitalization: TextCapitalization.words,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final category = controller.text.trim();

              if (category.isEmpty) return;

              Navigator.pop(
                context,
                _capitalizeFirstLetter(category),
              );
            },
            child: const Text('Add'),
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

  return value[0].toUpperCase() +
      value.substring(1);
}