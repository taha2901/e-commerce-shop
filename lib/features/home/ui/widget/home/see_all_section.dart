import 'package:easy_localization/easy_localization.dart';
import 'package:ecommerce_app/gen/locale_keys.g.dart';
import 'package:flutter/material.dart';

class SeeAllSectionHeader extends StatelessWidget {
  const SeeAllSectionHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          tr(LocaleKeys.newArrivals),
          style: theme.textTheme.titleLarge!.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onBackground, // ✅ بدل اللون الثابت
          ),
        ),
        Text(
          tr(LocaleKeys.seeAll),
          style: theme.textTheme.labelLarge!.copyWith(
            color: theme.colorScheme.primary, // ✅ يتغير مع اللايت/دارك
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
