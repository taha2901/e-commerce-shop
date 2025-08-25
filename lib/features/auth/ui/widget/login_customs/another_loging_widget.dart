import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AnotherLogingWidget extends StatelessWidget {
  const AnotherLogingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            color: theme.dividerColor, // بدل اللون الثابت
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            'أو سجل دخولك باستخدام',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
              fontSize: 14.sp,
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            color: theme.dividerColor, // بدل اللون الثابت
          ),
        ),
      ],
    );
  }
}
