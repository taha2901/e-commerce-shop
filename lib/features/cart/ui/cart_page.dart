import 'package:ecommerce_app/core/widget/custom_app_bar.dart';
import 'package:ecommerce_app/core/widget/spacing.dart';
import 'package:ecommerce_app/features/cart/logic/cart/cart_cubit.dart';
import 'package:ecommerce_app/features/cart/ui/widget/cart_item.dart';
import 'package:ecommerce_app/features/cart/ui/widget/cart_loading_widget.dart';
import 'package:ecommerce_app/features/cart/ui/widget/empty_cart.dart';
import 'package:ecommerce_app/features/checkout_payment/data/repos/checkout_repo_impl.dart';
import 'package:ecommerce_app/features/checkout_payment/presentation/manger/payment_cubit.dart';
import 'package:ecommerce_app/features/checkout_payment/views/widgets/payment_methods_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: Column(
          children: [
            const CustomHomeHeader(),
            SizedBox(height: 16.h),
            Expanded(
              child: BlocBuilder<CartCubit, CartState>(
                buildWhen: (previous, current) =>
                    current is CartLoading ||
                    current is CartLoaded ||
                    current is CartError ||
                    current is CartItemRemoving,
                builder: (context, state) {
                  if (state is CartLoading) {
                    return const CartLoadingWidget();
                  } else if (state is CartLoaded) {
                    if (state.cartItems.isEmpty) {
                      return EmptyCartWidget(
                        onStartShopping: () {
                          Navigator.of(context)
                              .popUntil((route) => route.isFirst);
                        },
                      );
                    }

                    return Column(
                      children: [
                        _buildCartHeader(context, state),
                        verticalSpace(16),
                        Expanded(child: _buildCartItemsList(context, state)),
                        _buildOrderSummary(context, state),
                        _buildCheckoutButton(context, state),
                      ],
                    );
                  } else if (state is CartItemRemoving) {
                    // إظهار loading أثناء حذف العنصر
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is CartError) {
                    return _buildErrorWidget(context, state);
                  }
                  return const Center(child: Text('Something went wrong!'));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartHeader(BuildContext context, CartLoaded state) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            Icons.shopping_cart_rounded,
            color: theme.colorScheme.primary,
            size: 24.sp,
          ),
          SizedBox(width: 12.w),
          Text(
            'My Cart',
            style: theme.textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${state.cartItems.length} ${state.cartItems.length == 1 ? 'item' : 'items'}',
              style: theme.textTheme.labelMedium!.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItemsList(BuildContext context, CartLoaded state) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: state.cartItems.length,
          padding: EdgeInsets.all(8.w),
          itemBuilder: (context, index) {
            return CartItemWidget(cartItem: state.cartItems[index]);
          },
          separatorBuilder: (context, index) => Divider(
            color: theme.dividerColor,
            height: 1,
            indent: 16.w,
            endIndent: 16.w,
          ),
        ),
      ),
    );
  }

  Widget _buildErrorWidget(BuildContext context, CartError state) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline,
              size: 64.sp, color: theme.colorScheme.error),
          SizedBox(height: 16.h),
          Text(
            'Oops! Something went wrong',
            style: theme.textTheme.titleMedium,
          ),
          SizedBox(height: 8.h),
          Text(
            state.message,
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary(BuildContext context, CartLoaded state) {
    final theme = Theme.of(context);
    const shipping = 10.0;
    final total = state.subtotal + shipping;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.receipt_long_rounded,
                  color: theme.colorScheme.primary, size: 24.sp),
              SizedBox(width: 12.w),
              Text(
                'Order Summary',
                style: theme.textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          _buildSummaryRow(context, 'Subtotal', state.subtotal),
          SizedBox(height: 12.h),
          _buildSummaryRow(context, 'Shipping', shipping),
          Divider(height: 32, color: theme.dividerColor),
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: theme.colorScheme.primary.withOpacity(0.2),
              ),
            ),
            child:
                _buildSummaryRow(context, 'Total Amount', total, isTotal: true),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(BuildContext context, String title, double amount,
      {bool isTotal = false}) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: theme.textTheme.bodyMedium!.copyWith(
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
          ),
        ),
        Text(
          '\$${amount.toStringAsFixed(2)}',
          style: theme.textTheme.titleMedium!.copyWith(
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            color: isTotal ? theme.colorScheme.primary : null,
          ),
        ),
      ],
    );
  }

  Widget _buildCheckoutButton(BuildContext context, CartLoaded state) {
    final theme = Theme.of(context);
    const shipping = 10.0;
    final total = state.subtotal + shipping;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 56.h,
        child: ElevatedButton.icon(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) {
                return BlocProvider(
                  create: (context) => PaymenttCubit(CheckoutRepoImpl()),
                  child: PaymentMethodsBottomSheet(total: total),
                );
              },
            );
          },
          icon: const Icon(Icons.shopping_bag_rounded),
          label: const Text('Proceed to Checkout'),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 14.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ),
    );
  }
}
