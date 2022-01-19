import 'package:curso_tdd/data/http/http.dart';
import 'package:curso_tdd/main/decorators/decorators.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:curso_tdd/data/cache/cache.dart';

class FetchSecureCacheStorageSpy extends Mock
    implements FetchSecureCacheStorage {}

class HttpClientSpy extends Mock implements IHttpClient {}

void main() {
  FetchSecureCacheStorageSpy fetchSecure;
  AuthorizeHttpClientDecorator sut;
  HttpClientSpy httpClient;
  String url;
  String method;
  Map body;
  String token;
  String httpResponse;

  PostExpectation mockTokenCall() => when(fetchSecure.fetchSecure(any));

  void mockToken() {
    token = faker.guid.guid();
    mockTokenCall().thenAnswer((_) async => token);
  }

  void mockTokenError() => mockTokenCall().thenThrow(Exception());

  PostExpectation mockHttpResponseCall() => when(httpClient.request(
      url: anyNamed('url'),
      method: anyNamed('method'),
      body: anyNamed('body'),
      headers: anyNamed('headers')));

  void mockHttpResponse() {
    httpResponse = faker.randomGenerator.string(50);

    mockHttpResponseCall().thenAnswer((_) async => httpResponse);
  }

  void mockHttpResponseError(HttpError error) =>
      mockHttpResponseCall().thenThrow(error);

  setUp(() {
    httpClient = HttpClientSpy();
    fetchSecure = FetchSecureCacheStorageSpy();
    sut = AuthorizeHttpClientDecorator(
        fetchSecureCacheStorage: fetchSecure, decoratee: httpClient);
    url = faker.internet.httpUrl();
    method = faker.randomGenerator.string(10);
    body = {'any_key': 'any_value'};
    mockToken();
    mockHttpResponse();
  });
  test('Should call FetchSecureCacheStorage with correct key', () async {
    await sut.request(method: method, url: url, body: body);

    verify(fetchSecure.fetchSecure('token')).called(1);
  });

  test('Should call decoratee with access token on header', () async {
    await sut.request(method: method, url: url, body: body);

    verify(httpClient.request(
        method: method,
        url: url,
        body: body,
        headers: {'x-access-token': token})).called(1);

    await sut.request(
        method: method,
        url: url,
        body: body,
        headers: {'any_header': 'any_value'});

    verify(httpClient.request(
            method: method,
            url: url,
            body: body,
            headers: {'x-access-token': token, 'any_header': 'any_value'}))
        .called(1);
  });

  test('Should return same result as decoratee', () async {
    final response = await sut.request(method: method, url: url, body: body);

    expect(response, httpResponse);
  });

  test('Should throws ForbiddenError if FetchSecureCacheStorage throws',
      () async {
    mockTokenError();
    final future = sut.request(method: method, url: url, body: body);

    expect(future, throwsA(HttpError.forbidden));
  });

  test('Should rethrows if decoratee throws', () async {
    mockHttpResponseError(HttpError.badRequest);
    final future = sut.request(method: method, url: url, body: body);

    expect(future, throwsA(HttpError.badRequest));
  });
}
