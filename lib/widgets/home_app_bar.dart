import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final bool isSearching;
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onSearch;
  final VoidCallback onCloseSearch;
  final VoidCallback onSummary;

  const HomeAppBar({
    super.key,
    required this.isSearching,
    required this.searchController,
    required this.onSearchChanged,
    required this.onSearch,
    required this.onCloseSearch,
    required this.onSummary,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.deepPurple,
      foregroundColor: Colors.white,

      title: isSearching
          ? TextField(
        controller: searchController,
        autofocus: true,
        style: const TextStyle(
          color: Colors.white,
        ),
        decoration: const InputDecoration(
          hintText: "Search expense...",
          hintStyle: TextStyle(
            color: Colors.white70,
          ),
          border: InputBorder.none,
        ),
        onChanged: onSearchChanged,
      )
          : const Text(
        "Expense Tracker",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 25,
        ),
      ),

      actions: [
        IconButton(
          onPressed: onSearch,
          icon: const Icon(Icons.search),
        ),

        if (isSearching)
          IconButton(
            onPressed: onCloseSearch,
            icon: const Icon(Icons.close),
          ),

        IconButton(
          onPressed: null,
          icon: const Icon(
            Icons.notifications_outlined,
          ),
        ),

        PopupMenuButton<String>(
          onSelected: (value) {
            if (value == "summary") {
              onSummary();
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: "summary",
              child: Text("Summary"),
            ),
            const PopupMenuItem(
              value: "profile",
              child: Text("Profile"),
            ),
            const PopupMenuItem(
              value: "settings",
              child: Text("Settings"),
            ),
            const PopupMenuItem(
              value: "logout",
              child: Text("Logout"),
            ),
          ],
        ),
      ],
    );
  }
}