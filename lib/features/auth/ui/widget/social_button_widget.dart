
import 'package:ecommerce_app/features/auth/ui/widget/login_customs/social_media_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SocialButtonWidget extends StatelessWidget {
  final String text;
  final String imgUrl;
  final VoidCallback onTap;
  final bool isLoading;
  final Color color;
  final Color borderColor;
  const SocialButtonWidget(
      {super.key,
      required this.text,
      required this.imgUrl,
      required this.onTap,
      required this.color,
      required this.borderColor,
      required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 56.h,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SocialMediaButton(
        isLoading: isLoading,
        text: text,
        imgUrl: imgUrl,
        onTap: onTap,
      ),
    );
  }
}
