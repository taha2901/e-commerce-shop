import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_app/core/widget/spacing.dart';
import 'package:ecommerce_app/features/favourite/logic/cubit/favourite_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductItemWidget extends StatelessWidget {
  final dynamic product;
  final FavouriteCubit favoriteCubit;

  const ProductItemWidget({
    super.key,
    required this.product,
    required this.favoriteCubit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.symmetric(vertical: 6.h, horizontal: 12.w),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
        border: Border.all(color: theme.dividerColor),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildProductImage(theme),
          horizontalSpace(16),
          _buildProductInfo(theme),
          _buildRemoveButton(context, theme),
        ],
      ),
    );
  }

  Widget _buildProductImage(ThemeData theme) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.r),
      child: buildProductImage(
        product.imgUrl,
        width: 60.w,
        height: 60.h,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget buildProductImage(String url,
      {double? width, double? height, BoxFit? fit}) {
    if (url.startsWith("http")) {
      return CachedNetworkImage(
        imageUrl: url,
        width: width,
        height: height,
        fit: fit ?? BoxFit.cover,
        placeholder: (_, __) =>
            const Center(child: CircularProgressIndicator()),
        errorWidget: (_, __, ___) => const Icon(Icons.broken_image),
      );
    } else {
      return Image.file(
        File(url),
        width: width,
        height: height,
        fit: fit ?? BoxFit.cover,
        errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
      );
    }
  }

  Widget _buildProductInfo(ThemeData theme) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product.name,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 6.h),
          Text(
            "\$${product.price}",
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.secondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRemoveButton(BuildContext context, ThemeData theme) {
    return Container(
      width: 40.w,
      height: 40.h,
      decoration: BoxDecoration(
        color: theme.colorScheme.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: IconButton(
        icon: Icon(
          Icons.delete_outline_rounded,
          color: theme.colorScheme.error,
          size: 22.sp,
        ),
        onPressed: () => _showDeleteConfirmation(context, theme),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, ThemeData theme) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          title: Row(
            children: [
              Icon(Icons.delete_outline_rounded,
                  color: theme.colorScheme.error, size: 24.sp),
              SizedBox(width: 8.w),
              Text(
                "Remove from Favorites",
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Text(
            'Are you sure you want to remove "${product.name}"?',
            style: theme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                "Cancel",
                style: TextStyle(color: theme.hintColor),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.error,
                foregroundColor: theme.colorScheme.onError,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                favoriteCubit.removeFavorite(product.id, context);
              },
              child: const Text("Remove"),
            ),
          ],
        );
      },
    );
  }
}
