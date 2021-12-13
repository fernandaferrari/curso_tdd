import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';

import 'package:curso_tdd/data/http/http_error.dart';
import 'package:curso_tdd/infra/http/http.dart';

class ClientMock extends Mock implements Client {}

void main() {
  late HttpAdapter sut;
  late ClientMock client;
  late String url;

  setUp(() {
    client = ClientMock();
    sut = HttpAdapter(client);
    url = faker.internet.httpUrl();
  });

  group('post', () {
    When mockrequest() => when(() => client.post(Uri.parse('any_value'),
        body: any(named: 'body'), headers: any(named: 'headers')));

    void mockResponse(int statusCode,
        {String body = '{"any_key":"any_value"}'}) {
      mockrequest().thenAnswer((_) async => Response(body, statusCode));
    }

    setUp(() {
      mockResponse(200);
    });

    test('Quando client.post tem os valores corretos ...', () async {
      await sut.request(url: url, method: 'post');

      verify(() => client.post(Uri.parse(url),
          headers: {
            'content-type': 'application/json',
            'accept': 'application/json'
          },
          body: '{"any_key:"any_value"}'));
    });

    test('Quando client.post está sem body...', () async {
      await sut.request(url: url, method: 'post');

      verify(() => client.post(any(), headers: any(named: 'headers')));
    });

    test('return data if post returns 200...', () async {
      final response = await sut.request(url: url, method: 'post');

      expect(response, {'any_key': 'any_value'});
    });

    test('return null if post returns 200 with no data...', () async {
      mockResponse(200, body: '');

      final response = await sut.request(url: url, method: 'post');

      expect(response, null);
    });

    test('return null if post returns 204...', () async {
      mockResponse(200, body: '');

      final response = await sut.request(url: url, method: 'post');

      expect(response, null);
    });

    test('return null if post returns 204 with data...', () async {
      mockResponse(200, body: '');

      final response = await sut.request(url: url, method: 'post');

      expect(response, null);
    });

    test('return error 404...', () async {
      mockResponse(404);

      final response = await sut.request(url: url, method: 'post');

      expect(response, throwsA(HttpError.badRequest));
    });
  });
}
