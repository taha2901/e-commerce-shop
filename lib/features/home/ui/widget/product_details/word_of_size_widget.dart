import 'package:flutter/material.dart';

class WordOFSizeWidget extends StatelessWidget {
  const WordOFSizeWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Text(
      'Size',
      style: theme.textTheme.titleMedium!.copyWith(
        fontWeight: FontWeight.bold,
        color: theme.colorScheme.onSurface, // يتكيف مع Light/Dark
      ),
    );
  }
}
