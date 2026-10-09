import 'package:flutter/material.dart';

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 5,
      ),
      minLeadingWidth: 42,
      leading: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: colorScheme.primary,
          size: 21,
        ),
      ),
      title: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: subtitle == null
          ? null
          : Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Text(
          subtitle!,
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
            height: 1.35,
          ),
        ),
      ),
      trailing: trailing ??
          (onTap != null
              ? Icon(
            Icons.chevron_right_rounded,
            color: colorScheme.onSurfaceVariant,
            size: 22,
          )
              : null),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      splashColor: colorScheme.primary.withValues(alpha: 0.08),
      hoverColor: colorScheme.primary.withValues(alpha: 0.05),
    );
  }
}