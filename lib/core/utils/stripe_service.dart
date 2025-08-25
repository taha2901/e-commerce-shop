
import 'package:dio/dio.dart';
import 'package:ecommerce_app/core/utils/api_key.dart';
import 'package:ecommerce_app/core/utils/api_service.dart';
import 'package:ecommerce_app/features/checkout_payment/data/models/ephemerel_key_model/ephemerel_key_model.dart';
import 'package:ecommerce_app/features/checkout_payment/data/models/init_payment_sheet_model.dart';
import 'package:ecommerce_app/features/checkout_payment/data/models/payment_intent_input_model.dart';
import 'package:ecommerce_app/features/checkout_payment/data/models/payment_intent_model/payment_intent_model.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class StripeService {
  final ApiService apiService = ApiService();

  Future<PaymentIntentModel?> createPaymentIntent(
    PaymentIntentInputModel paymentIntentInputModel,
  ) async {
    try {
      var response = await apiService.POST(
        body: paymentIntentInputModel.toJson(),
        contentType: Headers.formUrlEncodedContentType,
        url: 'https://api.stripe.com/v1/payment_intents',
        token: ApiKeys.secretKey,
        headers: {
          'Authorization': 'Bearer ${ApiKeys.secretKey}',
          'Content-Type': Headers.formUrlEncodedContentType,
        },
      );

      var paymentIntentModel = PaymentIntentModel.fromJson(response.data);
      return paymentIntentModel;
    } catch (e) {
      if (e is DioException) {
      } else {
        print('Unexpected error: $e');
      }
      return null; // إرجاع فارغ في حالة الخطأ
    }
  }

  Future initPaymentSheet({
    required InitPaymentSheetModel initPaymentSheetModel,
  }) async {
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: initPaymentSheetModel.clientSecret,
        customerEphemeralKeySecret: initPaymentSheetModel.ephemerelKeySecret,
        customerId: initPaymentSheetModel.customerId,
        merchantDisplayName: 'tharwat',
      ),
    );
  }

  Future displayPaymentSheet() async {
    await Stripe.instance.presentPaymentSheet();
  }

  Future<void> makePayment({
    required PaymentIntentInputModel paymentIntentInputModel,
  }) async {
    var paymentIntentModel = await createPaymentIntent(paymentIntentInputModel);
    var ephemerelKeyModel = await createEphemeralKey(
      customerId: paymentIntentInputModel.cusomerId,
    );
    var initPaymentSheetModel = InitPaymentSheetModel(
      clientSecret: paymentIntentModel!.clientSecret!,
      customerId: paymentIntentModel.customer!,
      ephemerelKeySecret: ephemerelKeyModel.secret!,
    );

    await initPaymentSheet(initPaymentSheetModel: initPaymentSheetModel);
    await displayPaymentSheet();
  }

  Future<EphemerelKeyModel> createEphemeralKey({
    required String customerId,
  }) async {
    var response = await apiService.POST(
      body: {'customer': customerId},
      contentType: Headers.formUrlEncodedContentType,
      url: 'https://api.stripe.com/v1/ephemeral_keys',
      token: ApiKeys.secretKey,
      headers: {
        'Authorization': "Bearer ${ApiKeys.secretKey}",
        'Content-Type': Headers.formUrlEncodedContentType,
        'Stripe-Version': '2025-03-31.basil',
      },
    );

    var ephermeralKey = EphemerelKeyModel.fromJson(response.data);

    return ephermeralKey;
  }
}
