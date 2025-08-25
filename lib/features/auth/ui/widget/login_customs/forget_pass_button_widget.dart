import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ForgetPasswordButton extends StatelessWidget {
  const ForgetPasswordButton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {},
        style: TextButton.styleFrom(
          foregroundColor: theme.colorScheme.primary, // يعتمد على الثيم
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
        ),
        child: Text(
          'نسيت كلمة المرور؟',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.primary, // يعتمد على الثيم
          ),
        ),
      ),
    );
  }
}
