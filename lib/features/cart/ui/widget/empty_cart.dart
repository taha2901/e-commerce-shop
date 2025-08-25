import 'package:easy_localization/easy_localization.dart';
import 'package:ecommerce_app/gen/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

class EmptyCartWidget extends StatefulWidget {
  final VoidCallback? onStartShopping;

  const EmptyCartWidget({super.key, this.onStartShopping});

  @override
  State<EmptyCartWidget> createState() => _EmptyCartWidgetState();
}

class _EmptyCartWidgetState extends State<EmptyCartWidget> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: AnimatedOpacity(
          opacity: 1.0,
          duration: const Duration(milliseconds: 500),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Iconsax.shopping_cart,
                size: 200,
                color: theme.colorScheme.onBackground.withOpacity(0.5),
              ),
              SizedBox(height: 24.h),
              Text(
                LocaleKeys.emptyCartTitle.tr(),
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                LocaleKeys.emptyCartMessage.tr(),
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                ),
              ),
              SizedBox(height: 32.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: widget.onStartShopping ??
                      () {
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                      },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primaryColor,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    LocaleKeys.emptyCartButton.tr(),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
