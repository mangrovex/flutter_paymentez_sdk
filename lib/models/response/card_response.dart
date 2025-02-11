import 'package:flutter_paymentez_sdk/models/response/card_register.dart';
import 'package:flutter_paymentez_sdk/utils/dynamic_ext.dart';

class CardsResponse {
  CardsResponse({required this.cards, required this.resultSize});

  factory CardsResponse.fromJson(Map<String, dynamic> json) {
    final data = json.getList('cards');

    final resp = <CardRegister>[];
    for (final el in data) {
      final itemJson = el as Map<String, dynamic>;
      final model = CardRegister.fromJson(itemJson);
      resp.add(model);
    }

    return CardsResponse(
      cards: resp,
      resultSize: json.getInt('result_size'),
    );
  }

  final List<CardRegister> cards;
  final int resultSize;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'cards': cards.map((e) => e.toJson()).toList(),
      'result_size': resultSize,
    };
  }
}
