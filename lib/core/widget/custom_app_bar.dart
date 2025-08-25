import 'package:easy_localization/easy_localization.dart';
import 'package:ecommerce_app/core/widget/my_text_app.dart';
import 'package:ecommerce_app/core/utils/app_colors.dart';
import 'package:ecommerce_app/features/chat_bot/my_bot.dart';
import 'package:ecommerce_app/gen/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

class CustomHomeHeader extends StatefulWidget {
  const CustomHomeHeader({super.key});

  @override
  State<CustomHomeHeader> createState() => _CustomHomeHeaderState();
}

class _CustomHomeHeaderState extends State<CustomHomeHeader> {
  String? currentImageUrl;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
      child: Row(
        children: [
          /// Avatar
          GestureDetector(
            onTap: () {
              // TODO: Navigate to profile page
            },
            child: CircleAvatar(
              radius: 28.r,
              backgroundColor: theme.colorScheme.surfaceVariant,
              backgroundImage:
                  currentImageUrl != null ? NetworkImage(currentImageUrl!) : null,
              child: currentImageUrl == null
                  ? Icon(Icons.person,
                      size: 32, color: theme.colorScheme.onSurfaceVariant)
                  : null,
            ),
          ),
          SizedBox(width: 12.w),

          /// Greeting + Name
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyTextApp(
                  title: '${LocaleKeys.good_evening.tr()} 👋',
                  color: theme.hintColor,
                  size: 14.sp,
                ),
                MyTextApp(
                  title: 'Taha Hamada',
                  color: theme.colorScheme.onBackground,
                  size: 18.sp,
                  // fontWeight: FontWeightHelper.bold,
                ),
              ],
            ),
          ),

          /// Actions (Notification + ChatBot)
          Row(
            children: [
              _buildActionIcon(
                context: context,
                icon: Iconsax.notification,
                onTap: () {
                  // TODO: Navigate to notifications page
                },
                showBadge: true,
              ),
              SizedBox(width: 10.w),
              _buildActionIcon(
                context: context,
                icon: Icons.smart_toy_outlined,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EcommerceChatBot(),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Reusable Action Icon
  Widget _buildActionIcon({
    required BuildContext context,
    required IconData icon,
    required VoidCallback onTap,
    bool showBadge = false,
  }) {
    final theme = Theme.of(context);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(50),
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: theme.shadowColor.withOpacity(0.1),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(icon,
                color: theme.iconTheme.color ?? AppColors.kGrayColor, size: 22),
          ),
        ),
        if (showBadge)
          Positioned(
            right: -1,
            top: -1,
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: theme.colorScheme.error,
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }
}
