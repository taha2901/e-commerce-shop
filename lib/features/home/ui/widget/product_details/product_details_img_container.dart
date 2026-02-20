import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_app/features/home/data/product_items_model.dart';
import 'package:flutter/material.dart';

class ProductDetailsImageContainer extends StatelessWidget {
  const ProductDetailsImageContainer({
    super.key,
    required this.size,
    required this.product,
  });

  final Size size;
  final ProductItemModel product;

  Widget _buildImage(String url) {
    if (url.startsWith("http")) {
      return CachedNetworkImage(
        imageUrl: url,
        height: size.height * 0.4,
        placeholder: (_, __) =>
            const Center(child: CircularProgressIndicator()),
        errorWidget: (_, __, ___) =>
            const Icon(Icons.broken_image, size: 50),
      );
    } else {
      return Image.file(
        File(url),
        height: size.height * 0.4,
        errorBuilder: (_, __, ___) =>
            const Icon(Icons.broken_image, size: 50),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: size.height * 0.52,
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.cardColor,
      ),
      child: Column(
        children: [
          SizedBox(height: size.height * 0.1),
          _buildImage(product.imgUrl),
        ],
      ),
    );
  }
}
