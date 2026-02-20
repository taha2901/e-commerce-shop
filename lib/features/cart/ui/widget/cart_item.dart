import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_app/core/widget/spacing.dart';
import 'package:ecommerce_app/features/cart/logic/cart/cart_cubit.dart';
import 'package:ecommerce_app/features/home/data/add_to_cart.dart';
import 'package:ecommerce_app/features/home/ui/widget/product_details/counter_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CartItemWidget extends StatelessWidget {
  final AddToCartModel cartItem;
  const CartItemWidget({super.key, required this.cartItem});

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<CartCubit>(context);
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(left: 16.0.w, right: 16.0.w, bottom: 8.0.h),
      child: Row(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
              borderRadius: BorderRadius.circular(16),
            ),
            child: _buildImage(cartItem.product.imgUrl),
          ),
          horizontalSpace(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 🔹 اسم المنتج + زر الحذف
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        cartItem.product.name,
                        style: theme.textTheme.titleMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    BlocBuilder<CartCubit, CartState>(
                      bloc: cubit,
                      buildWhen: (previous, current) =>
                          current is CartItemRemoving &&
                          current.productId == cartItem.product.id,
                      builder: (context, state) {
                        if (state is CartItemRemoving) {
                          return SizedBox(
                            width: 20.w,
                            height: 20.h,
                            child:
                                const CircularProgressIndicator(strokeWidth: 2),
                          );
                        }
                        return IconButton(
                          onPressed: () => _showDeleteDialog(context, cubit),
                          icon: Icon(
                            Icons.delete_outline,
                            color: theme.colorScheme.error,
                            size: 20.sp,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        );
                      },
                    ),
                  ],
                ),

                verticalSpace(4),

                /// 🔹 المقاس
                Text.rich(
                  TextSpan(
                    text: 'Size: ',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.hintColor,
                    ),
                    children: [
                      TextSpan(
                        text: cartItem.size.name,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),

                verticalSpace(12),

                /// 🔹 الكاونتر + السعر
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: CounterWidget(
                        value: cartItem.quantity,
                        onIncrement: () => cubit.incrementCounter(cartItem),
                        onDecrement: () => cubit.decrementCounter(cartItem),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '\$${(cartItem.quantity * cartItem.product.price).toStringAsFixed(1)}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          softWrap: false,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage(String url) {
    if (url.startsWith("http")) {
      return CachedNetworkImage(
        imageUrl: url,
        height: 115.h,
        width: 110.w,
        placeholder: (_, __) =>
            const Center(child: CircularProgressIndicator()),
        errorWidget: (_, __, ___) => const Icon(Icons.broken_image),
      );
    } else {
      return Image.file(
        File(url),
        height: 115.h,
        width: 110.w,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
      );
    }
  }

  void _showDeleteDialog(BuildContext context, CartCubit cubit) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Remove Item',
            style: theme.textTheme.titleLarge,
          ),
          content: Text(
            'Are you sure you want to remove "${cartItem.product.name}" from your cart?',
            style: theme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                cubit.removeFromCart(cartItem);
              },
              style: TextButton.styleFrom(
                foregroundColor: theme.colorScheme.error,
              ),
              child: const Text('Remove'),
            ),
          ],
        );
      },
    );
  }
}
