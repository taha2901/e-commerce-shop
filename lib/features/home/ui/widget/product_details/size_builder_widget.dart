import 'package:ecommerce_app/features/home/data/product_items_model.dart';
import 'package:ecommerce_app/features/home/logic/products_details_cubit/product_details_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SizeBuilderWidget extends StatelessWidget {
  const SizeBuilderWidget({
    super.key,
    required this.cubit,
  });

  final ProductDetailsCubit cubit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
      bloc: cubit,
      buildWhen: (previous, current) =>
          current is SizeSelected || current is ProductDetailsLoaded,
      builder: (context, state) {
        return Row(
          children: ProductSize.values
              .map(
                (size) => Padding(
                  padding: const EdgeInsets.only(top: 6.0, right: 8.0),
                  child: InkWell(
                    onTap: () {
                      cubit.selectSize(size);
                    },
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: state is SizeSelected && state.size == size
                            ? theme.colorScheme.primary
                            : theme.colorScheme.surfaceVariant, // يتغير حسب theme
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          size.name,
                          style: theme.textTheme.labelMedium!.copyWith(
                            color: state is SizeSelected && state.size == size
                                ? theme.colorScheme.onPrimary
                                : theme.colorScheme.onSurface, // يتغير حسب theme
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }
}
