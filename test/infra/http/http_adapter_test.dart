import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';

class ClientMock extends Mock implements Client {}

class HttpAdapter {
  final Client client;

  HttpAdapter(this.client);

  Future<void> request({
    required String url,
    required String method,
    Map? body,
  }) async {
    await client.post(Uri.parse(url));
  }
}

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
    test('Quando client.post tem os valores corretos ...', () async {
      when(() => client.post(Uri.parse(url)))
          .thenAnswer((_) async => Response('{}', 200));

      await sut.request(url: url, method: 'post');

      verify(() => client.post(Uri.parse(url)));
    });
  });

  group('get', () {});

  group('put', () {});
}
