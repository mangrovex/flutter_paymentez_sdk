import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_paymentez_sdk/models/models.dart';
import 'package:flutter_paymentez_sdk/src/paymentez.interface.dart';
import 'package:flutter_paymentez_sdk/utils/utils.dart';

class PaymentezImpl implements IPaymentez {
  PaymentezImpl({
    required this.client,
    required this.serverApplicationCode,
    required this.serverAppKey,
    required this.clientApplicationCode,
    required this.clientAppKey,
    this.isProd = false,
    this.isPCI = false,
  });

  final String serverApplicationCode;
  final String serverAppKey;
  final String clientApplicationCode;
  final String clientAppKey;
  final bool isProd;
  final bool isPCI;

  final http.Client client;

  String get _host =>
      isProd ? 'ccapi.paymentez.com ' : 'ccapi-stg.paymentez.com';

  Map<String, String> _headers({bool isServer = false}) {
    var appCode = isPCI ? serverApplicationCode : clientApplicationCode;
    var appKey = isPCI ? serverAppKey : clientAppKey;

    if (!isPCI && isServer) {
      appCode = serverApplicationCode;
      appKey = serverAppKey;
    }

    final authToken = PaymentezSecurity.getAuthToken(
      appCode: appCode,
      appKey: appKey,
    );
    return {'Auth-Token': authToken, 'Content-Type': 'application/json'};
  }

  @override
  Future<(CardsResponse?, PaymentezError?)> getAllCards(
    String userID,
  ) async {
    final url = Uri.https(_host, '/v2/card/list', {'uid': userID});
    final response = await client.get(
      url,
      headers: _headers(isServer: true),
    );

    final body = json.decode(response.body) as Map<String, dynamic>;

    if (response.statusCode == HttpStatus.ok) {
      final result = CardsResponse.fromJson(body);
      return (result, null);
    }

    return (null, PaymentezError.fromJson(body));
  }

  @override
  Future<(AddCardResponse?, PaymentezError?)> addCard(
    AddCardRequest newCard,
  ) async {
    final url = Uri.https(_host, '/v2/card/add');
    final response = await client.post(
      url,
      headers: _headers(),
      body: json.encode(newCard.toJson()),
    );

    final body = json.decode(response.body) as Map<String, dynamic>;

    if (response.statusCode == HttpStatus.ok) {
      final result = AddCardResponse.fromJson(body);
      return (result, null);
    }

    return (null, PaymentezError.fromJson(body));
  }

  @override
  Future<(DeleteCardResponse?, PaymentezError?)> deleteCard(
    DeleteCardRequest deleteCardRequest,
  ) async {
    final url = Uri.https(_host, '/v2/card/delete');

    final response = await client.post(
      url,
      headers: _headers(isServer: true),
      body: json.encode(deleteCardRequest.toJson()),
    );

    final body = json.decode(response.body) as Map<String, dynamic>;
    if (response.statusCode == HttpStatus.ok) {
      final result = DeleteCardResponse.fromJson(body);
      return (result, null);
    }

    return (null, PaymentezError.fromJson(body));
  }

  @override
  Future<(PayResponse?, PaymentezError?)> debit(PayRequest payRequest) async {
    final url = Uri.https(_host, '/v2/transaction/debit');

    final response = await client.post(
      url,
      headers: _headers(isServer: true),
      body: json.encode(payRequest.toJson()),
    );

    final body = json.decode(response.body) as Map<String, dynamic>;
    if (response.statusCode == HttpStatus.ok) {
      final result = PayResponse.fromJson(body);
      return (result, null);
    }

    return (null, PaymentezError.fromJson(body));
  }

  @override
  Future<(PayResponse?, PaymentezError?)> debitCC(
    PayPCIRequest payPCIRequest,
  ) async {
    final url = Uri.https(_host, '/v2/transaction/debit_cc');

    final response = await client.post(
      url,
      headers: _headers(),
      body: json.encode(payPCIRequest.toJson()),
    );

    final body = json.decode(response.body) as Map<String, dynamic>;
    if (response.statusCode == HttpStatus.ok) {
      final result = PayResponse.fromJson(body);
      return (result, null);
    }

    return (null, PaymentezError.fromJson(body));
  }

  @override
  Future<(RefundResponse?, PaymentezError?)> refund(
    RefundRequest payPCIRequest,
  ) async {
    final url = Uri.https(_host, '/v2/transaction/refund');

    final response = await client.post(
      url,
      headers: _headers(),
      body: json.encode(payPCIRequest.toJson()),
    );

    final body = json.decode(response.body) as Map<String, dynamic>;
    if (response.statusCode == HttpStatus.ok) {
      final result = RefundResponse.fromJson(body);
      return (result, null);
    }

    return (null, PaymentezError.fromJson(body));
  }
}
