import 'package:ecommerce_app/core/utils/app_colors.dart';
import 'package:ecommerce_app/core/widget/spacing.dart';
import 'package:ecommerce_app/features/auth/data/user_data.dart';
import 'package:flutter/material.dart';

class IdentifyUserWidget extends StatelessWidget {
  const IdentifyUserWidget({
    super.key,
    required this.user,
  });

  final UserData user;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor, // يدعم Light/Dark
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.person, color: AppColors.kPrimaryColor),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  user.username,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          verticalSpace(12),
          Row(
            children: [
              const Icon(Icons.email, color: AppColors.kPrimaryColor),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  user.email,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.textTheme.bodyMedium?.color,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
