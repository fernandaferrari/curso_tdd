import 'package:curso_tdd/data/usercases/usecase.dart';
import 'package:curso_tdd/domain/helpers/helpers.dart';
import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:curso_tdd/data/http/http.dart';
import 'package:curso_tdd/domain/usecases/usecases.dart';

import '../../../domain/mocks/mocks.dart';
import '../../../infra/mocks/mocks.dart';
import '../../mocks/mocks.dart';

void main() {
  late RemoteAddAccount sut;
  late HttpClientSpy httpClient;
  late String url;
  late AddAccountParams params;
  late Map apiResult;

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteAddAccount(httpClient: httpClient, url: url);
    params = ParamsFactory.makeAddAccount();
    apiResult = ApiFactory.makeAccountJson();
    httpClient.mockHttpResponse(apiResult);
  });

  test('Quando usar a URL certa HTTPClient', () async {
    await sut.add(params);

    verify(() => (httpClient.request(url: url, method: 'post', body: {
          'email': params.email,
          'password': params.password,
          'name': params.name,
          'passwordConfirmation': params.passwordConfirmation,
        })));
  });

  test('Quando ocorrer um erro inesperado pelo HttpClient returns 400',
      () async {
    httpClient.mockHttpResponseError(HttpError.badRequest);

    final future = sut.add(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Quando ocorrer um erro inesperado pelo HttpClient returns 404',
      () async {
    httpClient.mockHttpResponseError(HttpError.notFound);

    final future = sut.add(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Quando ocorrer um erro ServerError e HttpClient returns 500', () async {
    httpClient.mockHttpResponseError(HttpError.serverError);

    final future = sut.add(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test(
      'Quando ocorrer um erro InvalidCredentialsError e HttpClient returns 403',
      () async {
    httpClient.mockHttpResponseError(HttpError.forbidden);

    final future = sut.add(params);

    expect(future, throwsA(DomainError.emailInUse));
  });

  test('Quando retornar Addaccount e HttpClient returns 200', () async {
    final account = await sut.add(params);

    expect(account.token, apiResult['accessToken']);
  });

  test(
      'retorna throw UnexpectedError e HttpClient returns 200 quando a dados invalidos',
      () async {
    httpClient.mockHttpResponse({'invalid_key': 'invalid_value'});

    final future = sut.add(params);

    expect(future, throwsA(DomainError.unexpected));
  });
}
