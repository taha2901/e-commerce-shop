import 'package:ecommerce_app/core/routings/routers.dart';
import 'package:ecommerce_app/features/home/logic/home_cubit/home_cubit.dart';
import 'package:ecommerce_app/features/home/ui/widget/home/product_image_carousal.dart';
import 'package:ecommerce_app/features/home/ui/widget/home/product_item.dart';
import 'package:ecommerce_app/features/home/ui/widget/home/see_all_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeTabView extends StatelessWidget {
  const HomeTabView({super.key});

  @override
  Widget build(BuildContext context) {
    final homeCubit = context.read<HomeCubit>();
    final theme = Theme.of(context);

    return BlocBuilder<HomeCubit, HomeState>(
      bloc: homeCubit,
      buildWhen: (previous, current) =>
          current is HomeError ||
          current is HomeLoaded ||
          current is HomeLoading,
      builder: (context, state) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          child: () {
            if (state is HomeLoading) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            } else if (state is HomeLoaded) {
              return RefreshIndicator(
                onRefresh: () async => homeCubit.getHomeData(),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(4, 4, 4, 16),
                          child: TextField(
                            readOnly: true, // لو هتعمل search page منفصلة
                            onTap: () {
                              // TODO: navigate to search page
                            },
                            decoration: InputDecoration(
                              hintText: 'Search products...',
                              prefixIcon: const Icon(Icons.search_rounded),
                              filled: true,
                              fillColor: theme.colorScheme.surfaceVariant
                                  .withOpacity(0.5),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 14),
                            ),
                          ),
                        ),

                        /// 🔹 السلايدر
                        ProductImageCarousel(state: state),
                        SizedBox(height: 24.0.h),

                        /// 🔹 الهيدر
                        const SeeAllSectionHeader(),
                        SizedBox(height: 16.0.h),

                        /// 🔹 Responsive GridView
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final crossAxisCount = constraints.maxWidth >= 900
                                ? 4
                                : constraints.maxWidth >= 600
                                    ? 3
                                    : 2;

                            return GridView.builder(
                              itemCount: state.products.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                mainAxisSpacing: 20,
                                crossAxisSpacing: 12,
                                childAspectRatio: 0.75,
                              ),
                              itemBuilder: (context, index) {
                                final product = state.products[index];
                                return InkWell(
                                  borderRadius: BorderRadius.circular(12),
                                  onTap: () {
                                    Navigator.of(context, rootNavigator: true)
                                        .pushNamed(
                                      Routers.productDetailsRoute,
                                      arguments: product.id,
                                    );
                                  },
                                  child: ProductItem(productItem: product),
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else if (state is HomeError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline_rounded,
                        size: 48,
                        color: theme.colorScheme.error,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        state.errMessage,
                        style: theme.textTheme.titleMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      FilledButton.icon(
                        onPressed: () => homeCubit.getHomeData(),
                        icon: const Icon(Icons.refresh_rounded),
                        label: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return const SizedBox.shrink();
            }
          }(),
        );
      },
    );
  }
}
