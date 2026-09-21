import 'package:flutter/material.dart';

class HomeAppBar extends StatefulWidget
    implements PreferredSizeWidget {
  final bool isSearching;

  final Function(String) onSearchChanged;
  final VoidCallback onSearch;
  final VoidCallback onCloseSearch;
  final VoidCallback onSummary;
  final VoidCallback onReset;

  const HomeAppBar({
    super.key,
    required this.isSearching,
    required this.onSearchChanged,
    required this.onSearch,
    required this.onCloseSearch,
    required this.onSummary,
    required this.onReset,
  });

  @override
  State<HomeAppBar> createState() => _HomeAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _HomeAppBarState extends State<HomeAppBar> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();

    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.blueAccent,
      foregroundColor: Colors.white,
      title: widget.isSearching
          ? TextField(
        controller: _searchController,
        autofocus: true,
        decoration: const InputDecoration(
          hintText: 'Search expenses...',
          border: InputBorder.none,
        ),
        onChanged: widget.onSearchChanged,
      )
          : const Text('Expense Tracker',
        style: TextStyle(color: Colors.white),

      ),

      actions: [
        if (widget.isSearching)
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              _searchController.clear();
              widget.onCloseSearch();
            },
          )
        else ...[
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: widget.onSearch,
          ),

          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'summary') {
                widget.onSummary();
              }

              if (value == 'reset') {
                widget.onReset();
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: 'summary',
                child: Row(
                  children: [
                    Icon(Icons.bar_chart),
                    SizedBox(width: 10),
                    Text('Summary'),
                  ],
                ),
              ),

              PopupMenuItem(
                value: 'reset',
                child: Row(
                  children: [
                    Icon(Icons.delete_forever),
                    SizedBox(width: 10),
                    Text('Reset All Data'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}