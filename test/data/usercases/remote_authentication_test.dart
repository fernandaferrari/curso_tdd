import 'package:faker/faker.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'remote_authentication_test.mocks.dart';

class RemoteAuthentication {
  final IHttpClient httpClient;
  final String url;

  RemoteAuthentication({required this.httpClient, required this.url});

  Future<void> auth() async {
    await httpClient.request(url: url, method: 'post');
  }
}

abstract class IHttpClient {
  Future<void> request({required String url, required String method});
}

//class HttpClientMock extends Mock implements IHttpClient {}

@GenerateMocks([IHttpClient])
void main() {
  test('Quando usar a URL certa HTTPClient', () async {
    final httpClient = MockIHttpClient();

    final url = faker.internet.httpUrl();

    //classe que sempre esta testando = sut
    final sut = RemoteAuthentication(httpClient: httpClient, url: url);

    await sut.auth();

    verify(httpClient.request(url: url, method: 'post'));
  });
}
