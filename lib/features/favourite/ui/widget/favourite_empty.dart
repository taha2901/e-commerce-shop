import 'package:easy_localization/easy_localization.dart';
import 'package:ecommerce_app/gen/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

class FavouriteEmpty extends StatelessWidget {
  final VoidCallback? onStartShopping;

  const FavouriteEmpty({super.key, this.onStartShopping});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Iconsax.heart,
              size: 80.r,
              color: theme.colorScheme.primary.withOpacity(0.3),
            ),
            SizedBox(height: 24.h),

            /// Title
            Text(
              LocaleKeys.emptyFavouriteTitle.tr(),
              style: theme.textTheme.headlineSmall?.copyWith(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 12.h),

            /// Message
            Text(
              LocaleKeys.emptyFavouriteMessage.tr(),
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 16.sp,
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
              ),
            ),

            SizedBox(height: 32.h),

            /// CTA Button
            SizedBox(
              width: 0.8.sw,
              child: ElevatedButton.icon(
                onPressed: onStartShopping,
                icon: const Icon(Iconsax.shop),
                label: Text(
                  LocaleKeys.emptyFavouriteButton.tr(),
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
