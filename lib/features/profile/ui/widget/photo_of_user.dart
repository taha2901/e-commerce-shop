import 'package:flutter/material.dart';

class PhotoOfUser extends StatelessWidget {
  const PhotoOfUser({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CircleAvatar(
      radius: 50,
      backgroundColor: theme.colorScheme.primary.withOpacity(0.6),
      child: const Icon(Icons.person, size: 50, color: Colors.white),
    );
  }
}
