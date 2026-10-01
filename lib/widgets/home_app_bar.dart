import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final bool isSearching;

  final ValueChanged<String> onSearchChanged;
  final VoidCallback onSearch;
  final VoidCallback onCloseSearch;
  final VoidCallback onLogout;

  const HomeAppBar({
    super.key,
    required this.isSearching,
    required this.onSearchChanged,
    required this.onSearch,
    required this.onCloseSearch,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: isSearching
          ? TextField(
        autofocus: true,
        onChanged: onSearchChanged,
        decoration: const InputDecoration(
          hintText: 'Search expenses...',
          border: InputBorder.none,
        ),
      )
          : const Text(
        'Expense Tracker',
      ),

      actions: [
        if (isSearching)
          IconButton(
            onPressed: onCloseSearch,
            icon: const Icon(
              Icons.close,
            ),
          )
        else
          IconButton(
            onPressed: onSearch,
            icon: const Icon(
              Icons.search,
            ),
          ),

        // Temporary logout button
        IconButton(
          onPressed: onLogout,
          tooltip: 'Logout',
          icon: const Icon(
            Icons.logout_rounded,
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize =>
      const Size.fromHeight(kToolbarHeight);
}