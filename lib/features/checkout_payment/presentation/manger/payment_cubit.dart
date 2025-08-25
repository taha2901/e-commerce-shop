import 'dart:developer';
import 'package:ecommerce_app/features/checkout_payment/data/models/payment_intent_input_model.dart';
import 'package:ecommerce_app/features/checkout_payment/data/repos/checkout_repo.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'payment_state.dart';
class PaymenttCubit extends Cubit<PaymentState> {
  PaymenttCubit(this.checkoutRepo) : super(PaymentInitial());
  final CheckoutRepo checkoutRepo;

  Future makePayment(
      {required PaymentIntentInputModel paymentIntentInputModel}) async {
    emit(PaymentLoading());

    var data = await checkoutRepo.makePayment(
        paymentIntentInputModel: paymentIntentInputModel);

    data.fold(
      (l) => emit(PaymentFailure(l.errMessage)),
      (r) => emit(
        PaymentSuccess(),
      ),
    );
  }

  @override
  void onChange(Change<PaymentState> change) {
    log(change.toString());
    super.onChange(change);
  }
}
