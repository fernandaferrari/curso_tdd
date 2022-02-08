import 'package:curso_tdd/data/http/http.dart';
import 'package:curso_tdd/main/decorators/decorators.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../data/mocks/mocks.dart';

void main() {
  late FetchSecureCacheStorageSpy fetch;
  late DeleteSecureCacheStorageSpy delete;
  late AuthorizeHttpClientDecorator sut;
  late HttpClientSpy httpClient;
  late String url;
  late String method;
  late Map body;
  late String token;
  late String httpResponse;

  setUp(() {
    httpClient = HttpClientSpy();
    fetch = FetchSecureCacheStorageSpy();
    delete = DeleteSecureCacheStorageSpy();
    sut = AuthorizeHttpClientDecorator(
        fetchSecureCacheStorage: fetch,
        deleteSecureCacheStorage: delete,
        decoratee: httpClient);
    url = faker.internet.httpUrl();
    method = faker.randomGenerator.string(10);
    body = {'any_key': 'any_value'};
    token = faker.guid.guid();
    fetch.mockToken(token);
    httpResponse = faker.randomGenerator.string(50);
    httpClient.mockHttpResponse(httpResponse);
  });
  test('Should call FetchSecureCacheStorage with correct key', () async {
    await sut.request(method: method, url: url, body: body);

    verify(() => fetch.fetch('token')).called(1);
  });

  test('Should call decoratee with access token on header', () async {
    await sut.request(method: method, url: url, body: body);

    verify(() => httpClient.request(
        method: method,
        url: url,
        body: body,
        headers: {'x-access-token': token})).called(1);

    await sut.request(
        method: method,
        url: url,
        body: body,
        headers: {'any_header': 'any_value'});

    verify(() => httpClient.request(
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
    fetch.mockTokenError();
    final future = sut.request(method: method, url: url, body: body);

    expect(future, throwsA(HttpError.forbidden));
    verify(() => delete.delete('token')).called(1);
  });

  test('Should rethrows if decoratee throws', () async {
    httpClient.mockHttpResponseError(HttpError.badRequest);
    final future = sut.request(method: method, url: url, body: body);

    expect(future, throwsA(HttpError.badRequest));
  });

  test('Should delete cache if request throws ForbiddenError', () async {
    httpClient.mockHttpResponseError(HttpError.forbidden);
    final future = sut.request(method: method, url: url, body: body);

    await untilCalled(() => delete.delete('token'));

    expect(future, throwsA(HttpError.forbidden));
    verify(() => delete.delete('token')).called(1);
  });
}
