import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SocialLoginRow extends StatelessWidget {
  const SocialLoginRow({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Color googleBg = isDark ? Colors.red.shade900.withOpacity(0.2) : Colors.red.shade50;
    Color googleBorder = isDark ? Colors.red.shade700 : Colors.red.shade100;

    Color fbBg = isDark ? Colors.blue.shade900.withOpacity(0.2) : Colors.blue.shade50;
    Color fbBorder = isDark ? Colors.blue.shade700 : Colors.blue.shade100;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            // TODO: Google login
          },
          child: Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: googleBg,
              border: Border.all(color: googleBorder),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Image.network(
              'https://cdn1.iconfinder.com/data/icons/google-s-logo/150/Google_Icons-09-512.png',
              height: 24.w,
              width: 24.w,
            ),
          ),
        ),
        SizedBox(width: 16.w),
        InkWell(
          onTap: () {
            // TODO: Facebook login
          },
          child: Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: fbBg,
              border: Border.all(color: fbBorder),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Image.network(
              'https://www.freepnglogos.com/uploads/facebook-logo-icon/facebook-logo-icon-facebook-logo-png-transparent-svg-vector-bie-supply-15.png',
              height: 24.w,
              width: 24.w,
            ),
          ),
        ),
      ],
    );
  }
}
