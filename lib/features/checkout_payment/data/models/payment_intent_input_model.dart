class PaymentIntentInputModel {
  final String amount;
  final String currency;
  final String cusomerId;

  PaymentIntentInputModel({
    required this.cusomerId,
    required this.amount,
    required this.currency,
  });

  Map<String, dynamic> toJson() {
    return {
      'amount': '${amount}00', 
      'currency': currency,
      'customer': cusomerId,
    };
  }
}
