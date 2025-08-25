import 'package:ecommerce_app/core/widget/loading_indicator.dart';
import 'package:ecommerce_app/core/widget/message_display.dart';
import 'package:ecommerce_app/core/widget/spacing.dart';
import 'package:ecommerce_app/features/home/logic/products_details_cubit/product_details_cubit.dart';
import 'package:ecommerce_app/features/home/ui/widget/product_details/price_and_ad_cart_button_widget.dart';
import 'package:ecommerce_app/features/home/ui/widget/product_details/product_desc_section.dart';
import 'package:ecommerce_app/features/home/ui/widget/product_details/product_details_appbar.dart';
import 'package:ecommerce_app/features/home/ui/widget/product_details/product_details_img_container.dart';
import 'package:ecommerce_app/features/home/ui/widget/product_details/product_name_and_counter_widget.dart';
import 'package:ecommerce_app/features/home/ui/widget/product_details/size_builder_widget.dart';
import 'package:ecommerce_app/features/home/ui/widget/product_details/word_of_size_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductDetailsPage extends StatelessWidget {
  final String productId;
  const ProductDetailsPage({
    super.key,
    required this.productId,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final cubit = BlocProvider.of<ProductDetailsCubit>(context);
    final theme = Theme.of(context);

    return BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
      bloc: cubit,
      buildWhen: (previous, current) =>
          current is ProductDetailsLoading ||
          current is ProductDetailsLoaded ||
          current is ProductDetailsError,
      builder: (context, state) {
        if (state is ProductDetailsLoading) {
          return LoadingIndicator();
        } else if (state is ProductDetailsError) {
          return MessageDisplay(
            message: state.message,
          );
        } else if (state is ProductDetailsLoaded) {
          final product = state.product;
          return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: ProductDetailsAppBar(),
            body: Stack(
              children: [
                ProductDetailsImageContainer(size: size, product: product),
                Padding(
                  padding: EdgeInsets.only(top: size.height * 0.47),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: theme.scaffoldBackgroundColor, // يتوافق مع Light/Dark
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(36.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ProductNameAndCounterWidget(product: product, cubit: cubit),
                          verticalSpace(16),
                          WordOFSizeWidget(),
                          SizeBuilderWidget(cubit: cubit),
                          const SizedBox(height: 16),
                          ProductDescriptionSection(product: product),
                          const Spacer(),
                          PriceAndAddCartButtonWidget(product: product, cubit: cubit),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return const Scaffold(
            body: Center(
              child: Text('Something went wrong!'),
            ),
          );
        }
      },
    );
  }
}
