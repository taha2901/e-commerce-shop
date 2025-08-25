import 'package:ecommerce_app/features/home/data/product_items_model.dart';
import 'package:ecommerce_app/features/home/logic/products_details_cubit/product_details_cubit.dart';
import 'package:ecommerce_app/features/home/ui/widget/product_details/product_counter_bloc_builder.dart';
import 'package:flutter/material.dart';

class ProductNameAndCounterWidget extends StatelessWidget {
  const ProductNameAndCounterWidget({
    super.key,
    required this.product,
    required this.cubit,
  });

  final ProductItemModel product;
  final ProductDetailsCubit cubit;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product.name,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(
                  Icons.star,
                  color: colorScheme.tertiary, // يتغير حسب اللايت/دارك
                  size: 25,
                ),
                const SizedBox(width: 5),
                Text(
                  product.averageRate.toString(),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ],
        ),
        ProductCounterBlocBuilder(cubit: cubit, product: product),
      ],
    );
  }
}
