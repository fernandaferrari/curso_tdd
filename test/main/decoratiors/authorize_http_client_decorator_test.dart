import 'package:curso_tdd/data/http/http.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:meta/meta.dart';

import 'package:curso_tdd/data/cache/cache.dart';

class FetchSecureCacheStorageSpy extends Mock
    implements FetchSecureCacheStorage {}

class HttpClientSpy extends Mock implements IHttpClient {}

class AuthorizeHttpClientDecorator {
  final FetchSecureCacheStorage fetchSecureCacheStorage;
  final IHttpClient decoratee;

  AuthorizeHttpClientDecorator(
      {@required this.fetchSecureCacheStorage, @required this.decoratee});

  Future<void> request(
      {@required String url,
      @required String method,
      Map body,
      Map headers}) async {
    final token = await fetchSecureCacheStorage.fetchSecure('token');
    final authorizedHeaders = {'x-access-token': token};
    await decoratee.request(
        url: url, method: method, body: body, headers: authorizedHeaders);
  }
}

void main() {
  FetchSecureCacheStorageSpy fetchSecure;
  AuthorizeHttpClientDecorator sut;
  HttpClientSpy httpClient;
  String url;
  String method;
  Map body;
  String token;

  void mockToken() {
    token = faker.guid.guid();
    when(fetchSecure.fetchSecure(any)).thenAnswer((_) async => token);
  }

  setUp(() {
    httpClient = HttpClientSpy();
    fetchSecure = FetchSecureCacheStorageSpy();
    sut = AuthorizeHttpClientDecorator(
        fetchSecureCacheStorage: fetchSecure, decoratee: httpClient);
    url = faker.internet.httpUrl();
    method = faker.randomGenerator.string(10);
    body = {'any_key': 'any_value'};
    mockToken();
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
  });
}
