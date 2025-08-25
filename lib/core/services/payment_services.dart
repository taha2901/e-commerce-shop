// import 'package:cloud_functions/cloud_functions.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

abstract class PaymentService {
  Future<String?> createCustomer(String email, String name);
  Future<bool> processPayment({
    required double amount,
    required String customerId,
    String currency = 'usd',
  });
  Future<bool> processPaymentWithSheet({
    required double amount,
    required String customerId,
    String currency = 'usd',
  });
}

class PaymentServiceImpl implements PaymentService {
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  @override
  Future<String?> createCustomer(String email, String name) async {
    try {
      final result = await _functions.httpsCallable('createCustomer').call({
        'email': email,
        'name': name,
      });
      
      return result.data['customerId'];
    } catch (e) {
      print('Error creating customer: $e');
      return null;
    }
  }

  @override
  Future<bool> processPayment({
    required double amount,
    required String customerId,
    String currency = 'usd',
  }) async {
    try {
      // 1. إنشاء Payment Intent
      final result = await _functions.httpsCallable('createPaymentIntent').call({
        'amount': amount,
        'currency': currency,
        'customerId': customerId,
      });

      final clientSecret = result.data['clientSecret'];
      
      // 2. تأكيد الدفع باستخدام Payment Sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'Your Store Name',
          customerId: customerId,
          style: ThemeMode.system,
        ),
      );

      await Stripe.instance.presentPaymentSheet();
      return true;
    } on StripeException catch (e) {
      if (e.error.code == FailureCode.Canceled) {
        print('Payment was canceled');
      } else {
        print('Stripe Error: ${e.error.localizedMessage}');
      }
      return false;
    } catch (e) {
      print('Payment Error: $e');
      return false;
    }
  }

  @override
  Future<bool> processPaymentWithSheet({
    required double amount,
    required String customerId,
    String currency = 'usd',
  }) async {
    try {
      // 1. إنشاء Payment Intent
      final result = await _functions.httpsCallable('createPaymentIntent').call({
        'amount': amount,
        'currency': currency,
        'customerId': customerId,
      });

      final clientSecret = result.data['clientSecret'];
      
      // 2. تهيئة Payment Sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'Your Store Name',
          customerId: customerId,
          style: ThemeMode.system,
          appearance: const PaymentSheetAppearance(
            colors: PaymentSheetAppearanceColors(
              primary: Color(0xFF6200EE),
            ),
          ),
        ),
      );

      // 3. عرض Payment Sheet
      await Stripe.instance.presentPaymentSheet();
      
      return true;
    } on StripeException catch (e) {
      if (e.error.code == FailureCode.Canceled) {
        print('Payment was canceled');
      } else {
        print('Stripe Error: ${e.error.localizedMessage}');
      }
      return false;
    } catch (e) {
      print('Payment Error: $e');
      return false;
    }
  }
}