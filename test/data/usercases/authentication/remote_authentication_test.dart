import 'package:curso_tdd/data/usercases/authentication/authentication.dart';
import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:curso_tdd/data/http/http.dart';
import 'package:curso_tdd/domain/usecases/usecases.dart';
import 'package:curso_tdd/domain/helpers/helpers.dart';

import '../../../domain/mocks/mocks.dart';
import '../../../infra/mocks/mocks.dart';

class IHttpClientMock extends Mock implements IHttpClient {}

void main() {
  late RemoteAuthentication sut;
  late IHttpClientMock httpClient;
  late String url;
  late AuthenticationParams params;
  late Map apiResult;

  When mockRequest() => when(() => httpClient.request(
      url: any(named: 'url'),
      method: any(named: 'method'),
      body: any(named: 'body')));

  void mockHttpData(Map data) {
    apiResult = data;
    mockRequest().thenAnswer((_) async => data);
  }

  void mockHttpError(HttpError error) {
    mockRequest().thenThrow(error);
  }

  setUp(() {
    httpClient = IHttpClientMock();
    url = faker.internet.httpUrl();
    sut = RemoteAuthentication(httpClient: httpClient, url: url);
    params = ParamsFactory.makeAuthentication();
    mockHttpData(ApiFactory.makeAccountJson());
  });

  test('Quando usar a URL certa HTTPClient', () async {
    await sut.auth(params);

    verify(() => (httpClient.request(
        url: url,
        method: 'post',
        body: {'email': params.email, 'password': params.secret})));
  });

  test('Quando ocorrer um erro inesperado pelo HttpClient returns 400',
      () async {
    mockHttpError(HttpError.badRequest);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Quando ocorrer um erro inesperado pelo HttpClient returns 404',
      () async {
    mockHttpError(HttpError.notFound);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test(
      'Quando ocorrer um erro InvalidCredentialsError e HttpClient returns 401',
      () async {
    mockHttpError(HttpError.unauthorized);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.invalidCredentials));
  });

  test('Quando retornar Account e HttpClient returns 200', () async {
    final account = await sut.auth(params);

    expect(account.token, apiResult['accessToken']);
  });

  test(
      'Quando retornar throw UnexpectedError e HttpClient returns 200 quando a dados invalidos',
      () async {
    mockHttpData({'invalid_key': 'invalid_value'});

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });
}
