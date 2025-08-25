import 'package:ecommerce_app/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TitleAndSubtitleWidget extends StatelessWidget {
  const TitleAndSubtitleWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Center(
      child: Column(
        children: [
          Text(
            'إنشاء حساب جديد',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.h),
          Text(
            'أنشئ حسابك الآن واستمتع بتجربة تسوق مميزة',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: isDark ? Colors.grey.shade300 : AppColors.grey,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
