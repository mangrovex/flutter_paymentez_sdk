import 'package:flutter_paymentez_sdk/models/request/pay/card_token.dart';
import 'package:flutter_paymentez_sdk/models/request/pay/order_pay.dart';
import 'package:flutter_paymentez_sdk/models/request/pay/user_pay.dart';

class PayRequest {
  PayRequest({
    required this.user,
    required this.order,
    required this.card,
  });

  final UserPay user;
  final OrderPay order;
  late final CardToken card;

  Map<String, dynamic> toJson() => {
        'user': user.toJson(),
        'order': order.toJson(),
        'card': card.toJson(),
      };
}
