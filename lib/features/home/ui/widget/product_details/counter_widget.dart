import 'package:flutter/material.dart';

class CounterWidget extends StatelessWidget {
  final int value;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const CounterWidget({
    super.key,
    required this.value,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: onDecrement,
            icon: const Icon(Icons.remove),
            color: theme.colorScheme.primary,
          ),
          Text(
            value.toString(),
            style: theme.textTheme.titleMedium,
          ),
          IconButton(
            onPressed: onIncrement,
            icon: const Icon(Icons.add),
            color: theme.colorScheme.primary,
          ),
        ],
      ),
    );
  }
}
