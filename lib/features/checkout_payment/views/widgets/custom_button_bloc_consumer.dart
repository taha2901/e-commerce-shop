import 'package:ecommerce_app/features/checkout_payment/data/models/payment_intent_input_model.dart';
import 'package:ecommerce_app/features/checkout_payment/views/thank_you_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../presentation/manger/payment_cubit.dart';

class CustomButtonBlocConsumer extends StatelessWidget {
  final double total;
  const CustomButtonBlocConsumer({
    super.key,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocConsumer<PaymenttCubit, PaymentState>(
      listener: (context, state) {
        if (state is PaymentSuccess) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => ThankYouView(total: total.toStringAsFixed(2)),
            ),
          );
        }

        if (state is PaymentFailure) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.error_outline, color: Colors.white),
                  SizedBox(width: 8.w),
                  Expanded(child: Text(state.errMessage)),
                ],
              ),
              backgroundColor: Colors.red[600],
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
          debugPrint(state.errMessage);
        }
      },
      builder: (context, state) {
        return Container(
          width: double.infinity,
          height: 56.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                theme.primaryColor,
                theme.primaryColor.withOpacity(0.8),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: theme.primaryColor.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: state is PaymentLoading
                ? null
                : () {
                    PaymentIntentInputModel paymentIntentInputModel =
                        PaymentIntentInputModel(
                      amount: '${total.toInt()}',
                      currency: 'USD',
                      cusomerId: 'cus_SCZxTwXxxe7kWr',
                    );

                    BlocProvider.of<PaymenttCubit>(context)
                        .makePayment(paymentIntentInputModel: paymentIntentInputModel);
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.white,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
            child: state is PaymentLoading
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20.w,
                        height: 20.h,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        'Processing...',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.lock_rounded, size: 20.sp, color: Colors.white),
                      SizedBox(width: 8.w),
                      Text(
                        'Pay Securely',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}
