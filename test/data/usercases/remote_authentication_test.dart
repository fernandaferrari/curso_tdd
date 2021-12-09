import 'package:faker/faker.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'remote_authentication_test.mocks.dart';

import 'package:curso_tdd/data/usecases/usecase.dart';
import 'package:curso_tdd/data/http/http_client.dart';
import 'package:curso_tdd/domain/usecases/usecases.dart';

@GenerateMocks([IHttpClient])
void main() {
  RemoteAuthentication? sut;
  MockIHttpClient? httpClient;
  String? url;

  setUp(() {
    httpClient = MockIHttpClient();
    url = faker.internet.httpUrl();
    //classe que sempre esta testando = sut
    sut = RemoteAuthentication(httpClient: httpClient!, url: url!);
  });

  test('Quando usar a URL certa HTTPClient', () async {
    final params = AuthenticationParams(
        email: faker.internet.email(), secret: faker.internet.password());

    await sut!.auth(params);

    verify(httpClient!.request(
        url: url,
        method: 'post',
        body: {'email': params.email, 'password': params.secret}));
  });
}
