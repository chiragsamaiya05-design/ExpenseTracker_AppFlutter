import 'package:flutter/material.dart';

class AppBarWidget extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;

  const AppBarWidget({
    super.key,
    required this.title,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return AppBar(
      title: Text(
        title,
        style: theme.textTheme.titleLarge?.copyWith(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
        ),
      ),

      backgroundColor: theme.scaffoldBackgroundColor,
      foregroundColor: colorScheme.onSurface,

      elevation: 0,
      scrolledUnderElevation: 0,

      centerTitle: false,

      iconTheme: IconThemeData(
        color: colorScheme.onSurface,
        size: 24,
      ),

      actionsIconTheme: IconThemeData(
        color: colorScheme.onSurface,
        size: 22,
      ),

      actions: actions,

      surfaceTintColor: Colors.transparent,

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
  Size get preferredSize =>
      const Size.fromHeight(kToolbarHeight + 1);
}