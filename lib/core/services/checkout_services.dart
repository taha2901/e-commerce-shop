import 'package:ecommerce_app/core/helper/constants.dart';
import 'package:ecommerce_app/core/services/firestore_services.dart';
import 'package:ecommerce_app/features/cart/data/payment_card_model.dart';

abstract class CheckoutServices {
  Future<void> addNewCard(String userId, PaymentCardModel paymentCard);
  Future<List<PaymentCardModel>> fetchPaymentMedthod(String userId);
}

class CheckoutServicesImp implements CheckoutServices {
  final firestoreServices = FirestoreServices.instance;
  @override
  Future<void> addNewCard(String userId, PaymentCardModel paymentCard) async {
    await firestoreServices.setData(
        path: ApiPaths.paymentCard(userId, paymentCard.id),
        data: paymentCard.toMap());
  }

  @override
  Future<List<PaymentCardModel>> fetchPaymentMedthod(String userId) async {
    return await firestoreServices.getCollection(
      path: ApiPaths.paymentCards(userId),
      builder: (data, documentId) {
        return PaymentCardModel.fromMap(data);
      },
    );
  }
}
