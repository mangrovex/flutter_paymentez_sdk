import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_paymentez_sdk/models/models.dart';
import 'package:flutter_paymentez_sdk/src/paymentez.impl.dart';
import 'package:flutter_paymentez_sdk/utils/utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/helpers.dart';

class MockDioClient extends Mock implements Dio {}

void main() {
  late MockDioClient mockDioClient;
  late PaymentezImpl paymentez;

  setUpAll(() {
    registerFallbackValue(Options());
  });

  setUp(() {
    mockDioClient = MockDioClient();
    paymentez = PaymentezImpl(
      client: mockDioClient,
      serverApplicationCode: 'serverAppCode',
      serverAppKey: 'serverAppKey',
      clientApplicationCode: 'clientAppCode',
      clientAppKey: 'clientAppKey',
    );
  });

  group('Card', () {
    group('GetAllCards Method', () {
      test('Response Success', () async {
        final jsonResp = await Helpers.getJsonLocal(
          'test/mock',
          'get_cards_success.json',
        );

        final mockURI = Uri.parse(
          'https://ccapi-stg.paymentez.com/v2/card/list?uid=4',
        );

        final headerMock = {
          'Auth-Token': PaymentezSecurity.getAuthToken(
            appCode: paymentez.serverApplicationCode,
            appKey: paymentez.serverAppKey,
          ),
          'Content-Type': 'application/json',
        };

        when(
          () => mockDioClient.get(
            mockURI.toString(),
            options: any(named: 'options'),
          ),
        ).thenAnswer((invocation) async {
          final options = invocation.namedArguments[#options] as Options?;
          expect(options?.headers, headerMock);

          return Response(
            requestOptions: RequestOptions(path: mockURI.toString()),
            data: json.decode(jsonResp) as Map<String, dynamic>,
            statusCode: HttpStatus.ok,
          );
        });

        final (result, err) = await paymentez.getAllCards('4');

        expect(err, isNull);
        expect(result, isA<CardsResponse>());
        expect(result!.cards.length, 5);
      });

      test('Response Error', () async {
        final jsonResp = await Helpers.getJsonLocal(
          'test/mock',
          'get_cards_error.json',
        );

        final mockURI = Uri.parse(
          'https://ccapi-stg.paymentez.com/v2/card/list?uid=4',
        );

        final headerMock = {
          'Auth-Token': PaymentezSecurity.getAuthToken(
            appCode: paymentez.serverApplicationCode,
            appKey: paymentez.serverAppKey,
          ),
          'Content-Type': 'application/json',
        };

        when(
          () => mockDioClient.get(
            mockURI.toString(),
            options: any(named: 'options'),
          ),
        ).thenAnswer((invocation) async {
          final options = invocation.namedArguments[#options] as Options?;
          expect(options?.headers, headerMock);

          return Response(
            requestOptions: RequestOptions(path: mockURI.toString()),
            data: json.decode(jsonResp) as Map<String, dynamic>,
            statusCode: HttpStatus.unauthorized,
          );
        });

        final (result, err) = await paymentez.getAllCards('4');
        expect(result, isNull);
        expect(err, isA<PaymentezError>());
        expect(err!.error.type, 'Invalid Token');
      });
    });

    group('AddCard Method', () {
      test('Response Success', () async {
        final jsonResp = await Helpers.getJsonLocal(
          'test/mock',
          'add_card_success.json',
        );

        final mockURI = Uri.parse(
          'https://ccapi-stg.paymentez.com/v2/card/add',
        );

        final modelRequest = AddCardRequest(
          user: UserCard(id: 'data_mock', email: 'data_mock'),
          card: NewCard(
            number: 'data_mock',
            holderName: 'data_mock',
            expiryMonth: 1,
            expiryYear: 2023,
            cvc: 'data_mock',
          ),
        );

        final headerMock = {
          'Auth-Token': PaymentezSecurity.getAuthToken(
            appCode: paymentez.clientApplicationCode,
            appKey: paymentez.clientAppKey,
          ),
          'Content-Type': 'application/json',
        };

        when(
          () => mockDioClient.post(
            mockURI.toString(),
            data: any(named: 'data'),
            options: any(named: 'options'),
          ),
        ).thenAnswer((invocation) async {
          final options = invocation.namedArguments[#options] as Options?;
          expect(options?.headers, headerMock);
          expect(
            invocation.namedArguments[#data],
            json.encode(modelRequest.toJson()),
          );

          return Response(
            requestOptions: RequestOptions(path: mockURI.toString()),
            data: json.decode(jsonResp) as Map<String, dynamic>,
            statusCode: HttpStatus.ok,
          );
        });

        final (result, err) = await paymentez.addCard(modelRequest);

        expect(err, isNull);
        expect(result, isA<AddCardResponse>());
      });
      test('Response Error', () async {
        final jsonResp = await Helpers.getJsonLocal(
          'test/mock',
          'add_card_error.json',
        );

        final mockURI = Uri.parse(
          'https://ccapi-stg.paymentez.com/v2/card/add',
        );

        final modelRequest = AddCardRequest(
          user: UserCard(id: 'data_mock', email: 'data_mock'),
          card: NewCard(
            number: 'data_mock',
            holderName: 'data_mock',
            expiryMonth: 1,
            expiryYear: 2023,
            cvc: 'data_mock',
          ),
        );

        final headerMock = {
          'Auth-Token': PaymentezSecurity.getAuthToken(
            appCode: paymentez.clientApplicationCode,
            appKey: paymentez.clientAppKey,
          ),
          'Content-Type': 'application/json',
        };

        when(
          () => mockDioClient.post(
            mockURI.toString(),
            data: any(named: 'data'),
            options: any(named: 'options'),
          ),
        ).thenAnswer((invocation) async {
          final options = invocation.namedArguments[#options] as Options?;
          expect(options?.headers, headerMock);
          expect(
            invocation.namedArguments[#data],
            json.encode(modelRequest.toJson()),
          );

          return Response(
            requestOptions: RequestOptions(path: mockURI.toString()),
            data: json.decode(jsonResp) as Map<String, dynamic>,
            statusCode: HttpStatus.forbidden,
          );
        });

        final (result, err) = await paymentez.addCard(modelRequest);

        expect(result, isNull);
        expect(err, isA<PaymentezError>());
      });
    });

    group('DeleteCard Method', () {
      test('Response Success', () async {
        final jsonResp = await Helpers.getJsonLocal(
          'test/mock',
          'delete_card_success.json',
        );

        final mockURI = Uri.parse(
          'https://ccapi-stg.paymentez.com/v2/card/delete',
        );

        final modelRequest = DeleteCardRequest(
          cardToken: 'data_mock',
          userId: 'data_mock',
        );

        final headerMock = {
          'Auth-Token': PaymentezSecurity.getAuthToken(
            appCode: paymentez.serverApplicationCode,
            appKey: paymentez.serverAppKey,
          ),
          'Content-Type': 'application/json',
        };

        when(
          () => mockDioClient.post(
            mockURI.toString(),
            data: any(named: 'data'),
            options: any(named: 'options'),
          ),
        ).thenAnswer((invocation) async {
          final options = invocation.namedArguments[#options] as Options?;
          expect(options?.headers, headerMock);
          expect(
            invocation.namedArguments[#data],
            json.encode(modelRequest.toJson()),
          );

          return Response(
            requestOptions: RequestOptions(path: mockURI.toString()),
            data: json.decode(jsonResp) as Map<String, dynamic>,
            statusCode: HttpStatus.ok,
          );
        });

        final (result, err) = await paymentez.deleteCard(modelRequest);

        expect(err, isNull);
        expect(result, isA<DeleteCardResponse>());
      });
      test('Response Error', () async {
        final jsonResp = await Helpers.getJsonLocal(
          'test/mock',
          'delete_card_error.json',
        );

        final mockURI = Uri.parse(
          'https://ccapi-stg.paymentez.com/v2/card/delete',
        );

        final modelRequest = DeleteCardRequest(
          cardToken: 'data_mock',
          userId: 'data_mock',
        );

        final headerMock = {
          'Auth-Token': PaymentezSecurity.getAuthToken(
            appCode: paymentez.serverApplicationCode,
            appKey: paymentez.serverAppKey,
          ),
          'Content-Type': 'application/json',
        };

        when(
          () => mockDioClient.post(
            mockURI.toString(),
            data: any(named: 'data'),
            options: any(named: 'options'),
          ),
        ).thenAnswer((invocation) async {
          final options = invocation.namedArguments[#options] as Options?;
          expect(options?.headers, headerMock);
          expect(
            invocation.namedArguments[#data],
            json.encode(modelRequest.toJson()),
          );

          return Response(
            requestOptions: RequestOptions(path: mockURI.toString()),
            data: json.decode(jsonResp) as Map<String, dynamic>,
            statusCode: HttpStatus.internalServerError,
          );
        });

        final (result, err) = await paymentez.deleteCard(modelRequest);

        expect(result, isNull);
        expect(err, isA<PaymentezError>());
      });
    });
  });

  group('Charge', () {});

  group('Refund', () {});

  group('Information', () {});
}
