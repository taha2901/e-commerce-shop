
import 'package:ecommerce_app/core/services/payment_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  PaymentCubit() : super(PaymentInitial());

  final PaymentService _paymentService = PaymentServiceImpl();
  String? _customerId;

  Future<void> createCustomerIfNeeded(String email, String name) async {
    if (_customerId != null) return;
    
    emit(PaymentLoading());
    try {
      _customerId = await _paymentService.createCustomer(email, name);
      if (_customerId != null) {
        emit(CustomerCreated(_customerId!));
      } else {
        emit(PaymentError('Failed to create customer'));
      }
    } catch (e) {
      emit(PaymentError(e.toString()));
    }
  }

  Future<void> processPayment(double amount) async {
    if (_customerId == null) {
      emit(PaymentError('Customer not found. Please try again.'));
      return;
    }

    emit(PaymentProcessing());
    try {
      final success = await _paymentService.processPaymentWithSheet(
        amount: amount,
        customerId: _customerId!,
      );

      if (success) {
        emit(PaymentSuccess());
      } else {
        emit(PaymentError('Payment failed. Please try again.'));
      }
    } catch (e) {
      emit(PaymentError(e.toString()));
    }
  }

  void resetPayment() {
    emit(PaymentInitial());
  }
}