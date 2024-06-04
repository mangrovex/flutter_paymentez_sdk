import 'package:flutter_paymentez_sdk/models/models.dart';

abstract class IPaymentez {
  // Card
  Future<(CardsResponse?, PaymentezError?)> getAllCards(String userID);
  Future<(AddCardResponse?, PaymentezError?)> addCard(AddCardRequest newCard);
  Future<(DeleteCardResponse?, PaymentezError?)> deleteCard(
    DeleteCardRequest deleteCardRequest,
  );

  // Payment
  Future<(PayResponse?, PaymentezError?)> debit(PayRequest payRequest);
  Future<(PayResponse?, PaymentezError?)> debitCC(PayPCIRequest payPCIRequest);

  // Process
  Future<(RefundResponse?, PaymentezError?)> refund(
    RefundRequest refundRequest,
  );
}
