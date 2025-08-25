import 'package:flutter/material.dart';

class ProductDetailsAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const ProductDetailsAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Text(
        'Product Details',
        style: theme.textTheme.titleLarge,
      ),
      iconTheme: theme.iconTheme,
      actions: [
        IconButton(
          icon: Icon(Icons.favorite_border, color: theme.iconTheme.color),
          onPressed: () {},
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
