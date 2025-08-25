import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SocialRegisterRow extends StatelessWidget {
  const SocialRegisterRow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final googleBackground = isDark ? Colors.red.shade900.withOpacity(0.2) : Colors.red.shade50;
    final googleBorder = isDark ? Colors.red.shade700.withOpacity(0.5) : Colors.red.shade100;

    final facebookBackground = isDark ? Colors.blue.shade900.withOpacity(0.2) : Colors.blue.shade50;
    final facebookBorder = isDark ? Colors.blue.shade700.withOpacity(0.5) : Colors.blue.shade100;

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
              color: googleBackground,
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
              color: facebookBackground,
              border: Border.all(color: facebookBorder),
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
