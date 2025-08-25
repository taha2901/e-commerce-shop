// import 'package:bloc/bloc.dart';
// import 'package:ecommerce_app/core/services/auth_services.dart';
// import 'package:ecommerce_app/core/services/checkout_services.dart';
// import 'package:ecommerce_app/features/cart/data/payment_card_model.dart';
// import 'package:meta/meta.dart';
// part 'payment_state.dart';

// class PaymentCubit extends Cubit<PaymentState> {
//   PaymentCubit() : super(PaymentInitial());

//   // تحديد معرف وسيلة الدفع المختارة مسبقًا باستخدام أول بطاقة كافتراضي
//   String selectedPaymentId = dummyPaymentCards.first.id;
//   final checkoutServices = CheckoutServicesImp();
//   final authServices = AuthServicesImpl();

//   Future<void> addNewCard(String cardNumber, String cardHolderName,
//       String expiryDate, String cvv) async {
//     emit(AddNewCardLoading());
//     try {
//       final newCard = PaymentCardModel(
//         id: DateTime.now().toIso8601String(),
//         cardNumber: cardNumber,
//         cardHolderName: cardHolderName,
//         expiryDate: expiryDate,
//         cvv: cvv,
//       );
//       final currentUser = authServices.currentUser();

//       await checkoutServices.addNewCard(currentUser!.uid, newCard);
//       emit(AddNewCardSuccess());
//     } catch (e) {
//       emit(AddNewCardFailure(e.toString()));
//     }
//   }

//   Future<void> fetchPaymentMethods() async {
//     emit(FetchingPaymentMethods());

//     try {
//       final currentUser = authServices.currentUser();
//       final paymentCards =
//           await checkoutServices.fetchPaymentMedthod(currentUser!.uid);
//       emit(FetchedPaymentMethods(paymentCards));
//       final chosenPaymentMedthod = paymentCards[0];
//       if(paymentCards.isNotEmpty){
//         emit(PayemntChosen(chosenPayment: chosenPaymentMedthod));
//       }
      
//     } catch (e) {
//       emit(FetchPaymentMethodsError(e.toString()));
//     }
//   }

//   // دالة لتغيير وسيلة الدفع المختارة
//   void changePaymentMethod(String id) {
//     // وف كل مره تنادي عالميثود دي هيغير السيليكتيد بايمنت اي دي ويخزن فيها ال الاي دي اللي انت باعتهولي
//     selectedPaymentId = id;

//     // البحث عن البطاقة التي تحمل نفس المعرف لتعيينها كالبطاقة المختارة
//     var tempChosenPaymentMethod = dummyPaymentCards
//         .firstWhere((paymentCard) => paymentCard.id == selectedPaymentId);

//     // إطلاق حالة تشير إلى تغيير وسيلة الدفع بنجاح
//     emit(PayemntChosen(chosenPayment: tempChosenPaymentMethod));
//   }

//   // دالة لتأكيد وسيلة الدفع المختارة
//   void confirmPaymentMethod() {
//     emit(ConfirmPaymentLoading());
//     Future.delayed(
//       const Duration(seconds: 1),
//       () {
//         // البحث عن البطاقة المختارة باستخدام المعرف المخزن
//         var chosenPaymentMethod = dummyPaymentCards
//             .firstWhere((paymentCard) => paymentCard.id == selectedPaymentId);

//         // البحث عن البطاقة المختارة حاليًا (قبل التغيير)
//         var previousPaymentMethod = dummyPaymentCards.firstWhere(
//           (paymentCard) => paymentCard.isChosen == true,
//           orElse: () => dummyPaymentCards.first, // استخدام أول بطاقة كافتراضي
//         );

//         // إلغاء تحديد البطاقة السابقة
//         previousPaymentMethod = previousPaymentMethod.copyWith(isChosen: false);

//         // تعيين البطاقة الجديدة كـ "مختارة"
//         chosenPaymentMethod = chosenPaymentMethod.copyWith(isChosen: true);

//         // الحصول على فهرس البطاقة السابقة في القائمة
//         final previousIndex = dummyPaymentCards.indexWhere(
//             (paymentCard) => paymentCard.id == previousPaymentMethod.id);

//         // الحصول على فهرس البطاقة الجديدة في القائمة
//         final chosenIndex = dummyPaymentCards.indexWhere(
//             (paymentCard) => paymentCard.id == chosenPaymentMethod.id);

//         // استبدال البطاقة السابقة بالبطاقة المحدثة في القائمة
//         dummyPaymentCards[previousIndex] = previousPaymentMethod;

//         // استبدال البطاقة المختارة بالبطاقة المحدثة في القائمة
//         dummyPaymentCards[chosenIndex] = chosenPaymentMethod;

//         // إطلاق حالة نجاح بعد تحديث وسيلة الدفع
//         emit(ConfirmPaymentSuccess());
//       },
//     );
//   }
// }



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