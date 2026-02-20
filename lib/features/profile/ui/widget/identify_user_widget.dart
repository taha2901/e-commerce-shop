import 'package:ecommerce_app/features/auth/data/user_data.dart';
import 'package:flutter/material.dart';

class IdentifyUserWidget extends StatelessWidget {
  const IdentifyUserWidget({super.key, required this.user});
  final UserData user;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.4),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.15),
        ),
      ),
      child: Column(
        children: [
          _InfoRow(
            icon: Icons.person_rounded,
            label: 'Username',
            value: user.username,
            theme: theme,
          ),
          Divider(
            height: 24,
            color: theme.dividerColor.withOpacity(0.4),
          ),
          _InfoRow(
            icon: Icons.email_rounded,
            label: 'Email',
            value: user.email,
            theme: theme,
          ),
          Divider(
            height: 24,
            color: theme.dividerColor.withOpacity(0.4),
          ),
          _InfoRow(
            icon: Icons.verified_user_rounded,
            label: 'Role',
            value: user.role,
            theme: theme,
            valueColor: theme.colorScheme.primary,
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final ThemeData theme;
  final Color? valueColor;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.theme,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: theme.colorScheme.primary, size: 18),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.hintColor,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: valueColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}