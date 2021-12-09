import 'package:faker/faker.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'remote_authentication_test.mocks.dart';

import 'package:curso_tdd/data/http/http.dart';
import 'package:curso_tdd/data/usecases/usecase.dart';
import 'package:curso_tdd/domain/usecases/usecases.dart';
import 'package:curso_tdd/domain/helpers/helpers.dart';

@GenerateMocks([IHttpClient])
void main() {
  RemoteAuthentication? sut;
  MockIHttpClient? httpClient;
  String? url;
  AuthenticationParams? params;

  setUp(() {
    httpClient = MockIHttpClient();
    url = faker.internet.httpUrl();
    //classe que sempre esta testando = sut
    sut = RemoteAuthentication(httpClient: httpClient!, url: url!);
    params = AuthenticationParams(
        email: faker.internet.email(), secret: faker.internet.password());
  });

  test('Quando usar a URL certa HTTPClient', () async {
    when(httpClient!.request(
            url: anyNamed('url'),
            method: anyNamed('method'),
            body: anyNamed('body')))
        .thenAnswer((_) async =>
            {'acessToken': faker.guid.guid(), 'name': faker.person.name()});

    await sut!.auth(params!);

    verify(httpClient!.request(
        url: url,
        method: 'post',
        body: {'email': params!.email, 'password': params!.secret}));
  });

  test('Quando ocorrer um erro inesperado pelo HttpClient returns 400',
      () async {
    when(httpClient!.request(
            url: anyNamed('url'),
            method: anyNamed('method'),
            body: anyNamed('body')))
        .thenThrow(HttpError.badRequest);

    final future = sut!.auth(params!);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Quando ocorrer um erro inesperado pelo HttpClient returns 404',
      () async {
    when(httpClient!.request(
            url: anyNamed('url'),
            method: anyNamed('method'),
            body: anyNamed('body')))
        .thenThrow(HttpError.notFound);

    final future = sut!.auth(params!);

    expect(future, throwsA(DomainError.unexpected));
  });

  test(
      'Quando ocorrer um erro InvalidCredentialsError e HttpClient returns 401',
      () async {
    when(httpClient!.request(
            url: anyNamed('url'),
            method: anyNamed('method'),
            body: anyNamed('body')))
        .thenThrow(HttpError.unauthorized);

    final future = sut!.auth(params!);

    expect(future, throwsA(DomainError.invalidCredentials));
  });

  test('Quando retornar Account e HttpClient returns 200', () async {
    final acessToken = faker.guid.guid();

    when(httpClient!.request(
            url: anyNamed('url'),
            method: anyNamed('method'),
            body: anyNamed('body')))
        .thenAnswer((_) async =>
            {'acessToken': acessToken, 'name': faker.person.name()});

    final account = await sut!.auth(params!);

    expect(account.token, acessToken);
  });
}
