import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BackButtonWidget extends StatelessWidget {
  const BackButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = theme.brightness == Brightness.dark
        ? Colors.grey.shade800
        : Colors.grey.shade100;
    final iconColor = theme.brightness == Brightness.dark
        ? Colors.grey.shade200
        : Colors.grey.shade700;

    return Container(
      width: 44.w,
      height: 44.h,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Icon(
          Icons.arrow_back_ios_new,
          size: 20.r,
          color: iconColor,
        ),
      ),
    );
  }
}
