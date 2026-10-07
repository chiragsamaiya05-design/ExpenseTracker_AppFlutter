import 'package:expense_tracker/Screens/settings/profile_screen.dart';
import 'package:expense_tracker/Screens/settings/security_screen.dart';
import 'package:flutter/material.dart';

import '../../widgets/settings/settings_section.dart';
import '../../widgets/settings/settings_tile.dart';
import 'appearance_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: false,
      ),

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          children: [

            // Account
            SettingsSection(
              title: 'Account',
              children: [
                SettingsTile(
                  icon: Icons.person_outline_rounded,
                  title: 'Profile',
                  subtitle: 'Manage your personal information',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ProfileScreen(),
                      ),
                    );
                  },
                ),

                SettingsTile(
                  icon: Icons.lock_outline_rounded,
                  title: 'Security & Login',
                  subtitle: 'Password, OTP and login settings',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SecurityScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),

            // Preferences
            SettingsSection(
              title: 'Preferences',
              children: [
                SettingsTile(
                  icon: Icons.language_rounded,
                  title: 'Language',
                  subtitle: 'English',
                  onTap: () {},
                ),

                SettingsTile(
                  icon: Icons.currency_rupee_rounded,
                  title: 'Currency',
                  subtitle: 'Indian Rupee (₹)',
                  onTap: () {},
                ),

                SettingsTile(
                  icon: Icons.palette_outlined,
                  title: 'Appearance',
                  subtitle: 'System default',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AppearanceScreen(),
                      ),
                    );
                  },
                ),

                SettingsTile(
                  icon: Icons.notifications_none_rounded,
                  title: 'Notifications',
                  subtitle: 'Manage alerts and reminders',
                  onTap: () {},
                ),
              ],
            ),

            // Expenses
            SettingsSection(
              title: 'Expenses',
              children: [
                SettingsTile(
                  icon: Icons.category_outlined,
                  title: 'Categories',
                  subtitle: 'Manage expense categories',
                  onTap: () {},
                ),

                SettingsTile(
                  icon: Icons.repeat_rounded,
                  title: 'Recurring Expenses',
                  subtitle: 'Manage automatic expenses',
                  onTap: () {},
                ),

                SettingsTile(
                  icon: Icons.account_balance_wallet_outlined,
                  title: 'Budget Settings',
                  subtitle: 'Manage your budgets',
                  onTap: () {},
                ),
              ],
            ),

            // Data
            SettingsSection(
              title: 'Data & Backup',
              children: [
                SettingsTile(
                  icon: Icons.backup_outlined,
                  title: 'Backup & Restore',
                  subtitle: 'Protect and restore your data',
                  onTap: () {},
                ),

                SettingsTile(
                  icon: Icons.file_download_outlined,
                  title: 'Export Data',
                  subtitle: 'Export your expenses and records',
                  onTap: () {},
                ),
              ],
            ),

            // Support
            SettingsSection(
              title: 'Support',
              children: [
                SettingsTile(
                  icon: Icons.help_outline_rounded,
                  title: 'Help & FAQ',
                  subtitle: 'Get help using ExpenseTracker',
                  onTap: () {},
                ),

                SettingsTile(
                  icon: Icons.star_outline_rounded,
                  title: 'Rate App',
                  subtitle: 'Share your feedback',
                  onTap: () {},
                ),

                SettingsTile(
                  icon: Icons.info_outline_rounded,
                  title: 'About',
                  subtitle: 'ExpenseTracker',
                  onTap: () {},
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Logout
            Container(
              decoration: BoxDecoration(
                color: colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(18),
              ),
              child: SettingsTile(
                icon: Icons.logout_rounded,
                title: 'Logout',
                subtitle: 'Sign out of your account',
                onTap: () {
                  _showLogoutDialog(context);
                },
              ),
            ),

            const SizedBox(height: 28),

            Center(
              child: Text(
                'ExpenseTracker',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 4),

            Center(
              child: Text(
                'Version 1.0.0',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Logout?'),
          content: const Text(
            'Are you sure you want to logout from your account?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: colorScheme.error,
                foregroundColor: colorScheme.onError,
              ),
              onPressed: () {
                Navigator.pop(context);

                // Connect your AuthController logout here.
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}