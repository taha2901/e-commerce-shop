import 'package:ecommerce_app/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class MainButton extends StatelessWidget {
  final double height;
  final VoidCallback? onTap;
  final Color backgroundColor;
  final Color foregroundColor;
  final String? text;
  final bool isLoading;

  const MainButton({
    super.key,
    this.height = 56,
    this.onTap,
    this.backgroundColor = AppColors.primary,
    this.foregroundColor = AppColors.white,
    this.text,
    this.isLoading = false,
  }) : assert(
          text != null || isLoading == true,
          'Either provide text or set isLoading to true',
        );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator.adaptive(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                text!,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: foregroundColor,
                      fontWeight: FontWeight.bold,
                    ),
              ),
      ),
    );
  }
}
