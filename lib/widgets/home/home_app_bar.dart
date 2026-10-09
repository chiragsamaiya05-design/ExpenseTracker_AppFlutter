import 'package:flutter/material.dart';

import '../../Screens/settings/settings_screen.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onNotificationTap;
  final VoidCallback? onSearchTap;

  const HomeAppBar({
    super.key,
    this.onNotificationTap,
    this.onSearchTap,
  });

  String _getGreeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return 'Good morning';
    } else if (hour < 17) {
      return 'Good afternoon';
    } else {
      return 'Good evening';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: theme.scaffoldBackgroundColor,
      foregroundColor: colorScheme.onSurface,
      surfaceTintColor: Colors.transparent,
      titleSpacing: 16,

      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${_getGreeting()} 👋',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Expense Tracker',
            style: theme.textTheme.titleLarge?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),

      iconTheme: IconThemeData(
        color: colorScheme.onSurface,
        size: 23,
      ),

      actions: [
        IconButton(
          onPressed: onSearchTap,
          tooltip: 'Search',
          icon: const Icon(Icons.search_rounded),
        ),
        IconButton(
          onPressed: onNotificationTap,
          tooltip: 'Notifications',
          icon: const Icon(Icons.notifications_none_rounded),
        ),
        IconButton(
          tooltip: 'Settings',
          icon: const Icon(Icons.settings_outlined),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const SettingsScreen(),
              ),
            );
          },
        ),
        const SizedBox(width: 6),
      ],

      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          color: colorScheme.outlineVariant.withValues(
            alpha: isDark ? 0.35 : 0.5,
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1);
}