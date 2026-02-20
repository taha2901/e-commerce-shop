import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_app/features/home/data/product_items_model.dart';
import 'package:ecommerce_app/features/home/logic/home_cubit/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductItem extends StatelessWidget {
  final ProductItemModel productItem;
  const ProductItem({super.key, required this.productItem});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.08),
            blurRadius: 16,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Image Section ──
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                child: Container(
                  height: 130, 
                  width: double.infinity,
                  color: theme.colorScheme.surfaceVariant,
                  child: _buildImage(productItem.imgUrl),

                ),
              ),

              // ── Favorite Button ──
              Positioned(
                top: 8,
                right: 8,
                child: BlocBuilder<HomeCubit, HomeState>(
                  buildWhen: (prev, curr) =>
                      (curr is SetFavouriteSuccess && curr.productId == productItem.id) ||
                      (curr is SetFavouriteLoading && curr.productId == productItem.id) ||
                      (curr is SetFavouriteFailure && curr.productId == productItem.id) ||
                      curr is HomeLoaded,
                  builder: (context, state) {
                    final homeCubit = context.read<HomeCubit>();
                    final isLoading = state is SetFavouriteLoading &&
                        state.productId == productItem.id;

                    bool isFav = homeCubit.isProductFavorite(productItem.id);
                    if (state is SetFavouriteSuccess &&
                        state.productId == productItem.id) {
                      isFav = state.isFav;
                    }

                    return GestureDetector(
                      onTap: isLoading
                          ? null
                          : () => homeCubit.setFavourite(productItem, context),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: theme.colorScheme.surface.withOpacity(0.92),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                        child: isLoading
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator.adaptive(
                                    strokeWidth: 2),
                              )
                            : AnimatedSwitcher(
                                duration: const Duration(milliseconds: 250),
                                child: Icon(
                                  isFav
                                      ? Icons.favorite_rounded
                                      : Icons.favorite_border_rounded,
                                  key: ValueKey(isFav),
                                  color: isFav ? Colors.red : theme.hintColor,
                                  size: 20,
                                ),
                              ),
                      ),
                    );
                  },
                ),
              ),

              // ── Discount Badge (اختياري) ──
              // لو عندك discount في الـ model
              // Positioned(top: 8, left: 8, child: _DiscountBadge(...))
            ],
          ),

          // ── Info Section ──
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  productItem.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  productItem.category,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.hintColor,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${productItem.price}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    // ✅ Add to Cart quick button
                    InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () {
                        // TODO: add to cart
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.add_shopping_cart_rounded,
                          size: 16,
                          color: theme.colorScheme.onPrimary,
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
      fit: BoxFit.cover,
      placeholder: (_, __) =>
          const Center(child: CircularProgressIndicator()),
      errorWidget: (_, __, ___) =>
          const Icon(Icons.broken_image),
    );
  } else {
    return Image.file(
      File(url),
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) =>
          const Icon(Icons.broken_image),
    );
  }
}

}