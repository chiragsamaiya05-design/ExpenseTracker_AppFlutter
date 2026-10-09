import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/theme_controller.dart';
import '../../widgets/settings/theme_option.dart';

class AppearanceScreen extends StatelessWidget {
  const AppearanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = context.watch<ThemeController>();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      appBar: AppBar(
        title: Text(
          'Appearance',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        backgroundColor: theme.scaffoldBackgroundColor,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
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
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Theme',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            'Choose how ExpenseTracker looks on your device.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),

          const SizedBox(height: 24),

          ThemeOption(
            title: 'Light',
            subtitle: 'Always use the light theme',
            icon: Icons.light_mode_rounded,
            value: ThemeMode.light,
            selected: themeController.themeMode,
            onTap: () {
              themeController.setTheme(ThemeMode.light);
            },
          ),

          const SizedBox(height: 12),

          ThemeOption(
            title: 'Dark',
            subtitle: 'Always use the dark theme',
            icon: Icons.dark_mode_rounded,
            value: ThemeMode.dark,
            selected: themeController.themeMode,
            onTap: () {
              themeController.setTheme(ThemeMode.dark);
            },
          ),

          const SizedBox(height: 12),

          ThemeOption(
            title: 'System default',
            subtitle: 'Follow your device settings',
            icon: Icons.settings_suggest_rounded,
            value: ThemeMode.system,
            selected: themeController.themeMode,
            onTap: () {
              themeController.setTheme(ThemeMode.system);
            },
          ),

          const SizedBox(height: 28),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: colorScheme.outlineVariant.withValues(
                  alpha: isDark ? 0.4 : 0.6,
                ),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.info_outline_rounded,
                    color: colorScheme.primary,
                    size: 21,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Theme preference',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        'Your theme preference is saved automatically. '
                            'System default follows your device settings.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}