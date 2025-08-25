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

    return Column(
      children: [
        Stack(
          children: [
            Container(
              height: 90,
              width: 220,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                color: theme.colorScheme.surfaceVariant, // ✅ بدل grey ثابتة
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CachedNetworkImage(
                  imageUrl: productItem.imgUrl,
                  fit: BoxFit.contain,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator.adaptive(),
                  ),
                  errorWidget: (context, url, error) => Icon(
                    Icons.error,
                    color: theme.colorScheme.error, // ✅ بدل Colors.red
                  ),
                ),
              ),
            ),
            Positioned(
              top: 8.0,
              right: 8.0,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.colorScheme.surface.withOpacity(0.7), // ✅ بدل white54
                ),
                child: BlocBuilder<HomeCubit, HomeState>(
                  buildWhen: (previous, current) {
                    return (current is SetFavouriteSuccess &&
                            current.productId == productItem.id) ||
                           (current is SetFavouriteLoading &&
                            current.productId == productItem.id) ||
                           (current is SetFavouriteFailure &&
                            current.productId == productItem.id) ||
                           (current is HomeLoaded);
                  },
                  builder: (context, state) {
                    final homeCubit = context.read<HomeCubit>();
                    
                    if (state is SetFavouriteLoading && 
                        state.productId == productItem.id) {
                      return const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator.adaptive(strokeWidth: 2),
                      );
                    }
                    
                    bool isFavorite = homeCubit.isProductFavorite(productItem.id);
                    
                    if (state is SetFavouriteSuccess && 
                        state.productId == productItem.id) {
                      isFavorite = state.isFav;
                    }
                    
                    return InkWell(
                      onTap: () async => await homeCubit.setFavourite(productItem, context),
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite 
                          ? Colors.red 
                          : theme.iconTheme.color?.withOpacity(0.7), // ✅ بدل grey
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4.0),
        Text(
          productItem.name,
          style: theme.textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        Text(
          productItem.category,
          style: theme.textTheme.labelMedium!.copyWith(
                color: theme.hintColor, // ✅ بدل Colors.grey
              ),
        ),
        Text(
          '\$${productItem.price}',
          style: theme.textTheme.titleSmall!.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.primary, // ✅ يدي لون البراند
              ),
        ),
      ],
    );
  }
}
