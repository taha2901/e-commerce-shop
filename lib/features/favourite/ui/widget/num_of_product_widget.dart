import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NumberOfProductsWidget extends StatelessWidget {
  const NumberOfProductsWidget({
    super.key,
    required this.favoriteProducts,
  });

  final List favoriteProducts;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Row(
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 20.sp,
            color: theme.iconTheme.color?.withOpacity(0.8),
          ),
          SizedBox(width: 8.w),
          Text(
            '${favoriteProducts.length} '
            '${favoriteProducts.length == 1 ? 'item' : 'items'} in favorites',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: theme.textTheme.bodyMedium?.color?.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }
}
