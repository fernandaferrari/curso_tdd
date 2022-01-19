import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:meta/meta.dart';

import 'package:curso_tdd/data/cache/cache.dart';

class FetchSecureCacheStorageSpy extends Mock
    implements FetchSecureCacheStorage {}

class AuthorizeHttpClientDecorator {
  final FetchSecureCacheStorage fetchSecureCacheStorage;
  AuthorizeHttpClientDecorator({
    @required this.fetchSecureCacheStorage,
  });

  Future<void> request() async {
    await fetchSecureCacheStorage.fetchSecure('token');
  }
}

void main() {
  FetchSecureCacheStorageSpy fetchSecure;
  AuthorizeHttpClientDecorator sut;

  setUp(() {
    fetchSecure = FetchSecureCacheStorageSpy();
    sut = AuthorizeHttpClientDecorator(fetchSecureCacheStorage: fetchSecure);
  });
  test('Should call FetchSecureCacheStorage with correct key', () async {
    await sut.request();

    verify(fetchSecure.fetchSecure('token')).called(1);
  });
}
