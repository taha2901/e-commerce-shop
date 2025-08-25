import 'package:ecommerce_app/core/widget/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CartLoadingWidget extends StatelessWidget {
  const CartLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              theme.primaryColor,
            ),
          ),
          verticalSpace(16),
          Text(
            'Loading your cart...',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: 16.sp,
              color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}
