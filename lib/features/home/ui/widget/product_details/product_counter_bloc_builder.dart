import 'package:ecommerce_app/features/home/data/product_items_model.dart';
import 'package:ecommerce_app/features/home/logic/products_details_cubit/product_details_cubit.dart';
import 'package:ecommerce_app/features/home/ui/widget/product_details/counter_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductCounterBlocBuilder extends StatelessWidget {
  const ProductCounterBlocBuilder({
    super.key,
    required this.cubit,
    required this.product,
  });

  final ProductDetailsCubit cubit;
  final ProductItemModel product;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
      bloc: cubit,
      buildWhen: (previous, current) =>
          current is QuantityCounterLoaded || current is ProductDetailsLoaded,
      builder: (context, state) {
        int currentValue = cubit.quantity; // fallback للقيمة من الكيوبت

        if (state is QuantityCounterLoaded) {
          currentValue = state.value;
        } else if (state is ProductDetailsLoaded) {
          currentValue = 1; // قيمة افتراضية أول ما يحمل المنتج
        }

        return CounterWidget(
          value: currentValue,
          onIncrement: cubit.incrementCounter,
          onDecrement: cubit.decrementCounter,
        );
      },
    );
  }
}
