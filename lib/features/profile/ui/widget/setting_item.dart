import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingItem extends StatelessWidget {
  final IconData? icon;
  final String title;
  final VoidCallback onTap;
  final Color color;

  const SettingItem({
    super.key,
    this.icon,
    required this.title,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Material(
        color: theme.colorScheme.surface, // لون الخلفية متوافق مع الثيم
        borderRadius: BorderRadius.circular(16),
        elevation: 1,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
            child: Row(
              children: [
                // أيقونة في دائرة ملونة
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 22),
                ),
                SizedBox(width: 12.w),

                // العنوان
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                // سهم أو فارغ للـ Logout
                if (title.toLowerCase() != 'logout')
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                    color: theme.iconTheme.color?.withOpacity(0.6),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
