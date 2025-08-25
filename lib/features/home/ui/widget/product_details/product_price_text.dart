import 'package:ecommerce_app/features/home/data/product_items_model.dart';
import 'package:flutter/material.dart';

class ProductPriceText extends StatelessWidget {
  const ProductPriceText({
    super.key,
    required this.product,
  });

  final ProductItemModel product;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Text.rich(
      TextSpan(
        text: '\$',
        style: theme.textTheme.titleLarge!.copyWith(
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.primary, // يتغير حسب Theme
        ),
        children: [
          TextSpan(
            text: product.price.toString(),
            style: theme.textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.textTheme.titleLarge!.color, // يتكيف مع Theme
            ),
          ),
        ],
      ),
    );
  }
}
