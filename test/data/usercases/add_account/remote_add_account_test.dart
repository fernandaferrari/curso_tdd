import 'package:curso_tdd/data/usercases/authentication/authentication.dart';
import 'package:curso_tdd/data/usercases/usecase.dart';
import 'package:curso_tdd/domain/helpers/helpers.dart';
import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:curso_tdd/data/http/http.dart';
import 'package:curso_tdd/domain/usecases/usecases.dart';

class IHttpClientMock extends Mock implements IHttpClient {}

void main() {
  RemoteAddAccount sut;
  IHttpClientMock httpClient;
  String url;
  AddAccountParams params;

  PostExpectation mockRequest() => when(httpClient.request(
      url: anyNamed('url'),
      method: anyNamed('method'),
      body: anyNamed('body')));

  void mockHttpError(HttpError error) {
    mockRequest().thenThrow(error);
  }

  setUp(() {
    httpClient = IHttpClientMock();
    url = faker.internet.httpUrl();
    sut = RemoteAddAccount(httpClient: httpClient, url: url);
    params = AddAccountParams(
      email: faker.internet.email(),
      password: faker.internet.password(),
      name: faker.person.name(),
      passwordConfirmation: faker.internet.password(),
    );
  });

  test('Quando usar a URL certa HTTPClient', () async {
    await sut.add(params);

    verify((httpClient.request(url: url, method: 'post', body: {
      'email': params.email,
      'password': params.password,
      'name': params.name,
      'passwordConfirmation': params.passwordConfirmation,
    })));
  });

  test('Quando ocorrer um erro inesperado pelo HttpClient returns 400',
      () async {
    mockHttpError(HttpError.badRequest);

    final future = sut.add(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Quando ocorrer um erro inesperado pelo HttpClient returns 404',
      () async {
    mockHttpError(HttpError.notFound);

    final future = sut.add(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Quando ocorrer um erro ServerError e HttpClient returns 500', () async {
    mockHttpError(HttpError.serverError);

    final future = sut.add(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test(
      'Quando ocorrer um erro InvalidCredentialsError e HttpClient returns 403',
      () async {
    mockHttpError(HttpError.forbidden);

    final future = sut.add(params);

    expect(future, throwsA(DomainError.emailInUse));
  });
}
