import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AnotherLogger extends StatelessWidget {
  const AnotherLogger({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lineColor = theme.dividerColor; // يستخدم اللون المناسب للثيم
    final textColor = theme.textTheme.bodyMedium?.color?.withOpacity(0.6);

    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            color: lineColor,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            'أو سجل باستخدام',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: textColor,
              fontSize: 14.sp,
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            color: lineColor,
          ),
        ),
      ],
    );
  }
}
