import 'package:ecommerce_app/features/home/data/product_items_model.dart';
import 'package:flutter/material.dart';

class ProductDescriptionSection extends StatelessWidget {
  const ProductDescriptionSection({
    super.key,
    required this.product,
  });

  final ProductItemModel product;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8.0),
        Text(
          product.description,
          style: Theme.of(context).textTheme.labelMedium!.copyWith(
                color: Theme.of(context).textTheme.labelMedium!.color,
              ),
        ),
      ],
    );
  }
}
