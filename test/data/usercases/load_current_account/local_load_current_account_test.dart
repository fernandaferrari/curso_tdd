import 'package:curso_tdd/data/cache/cache.dart';
import 'package:curso_tdd/data/usercases/usecase.dart';
import 'package:curso_tdd/domain/entities/entities.dart';
import 'package:curso_tdd/domain/helpers/helpers.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class FetchSecureCacheStorageSpy extends Mock
    implements FetchSecureCacheStorage {}

void main() {
  late FetchSecureCacheStorageSpy fetchSecureCacheStorage;
  late LocalLoadCurrentAccount sut;
  late String token;

  When mockFetchSecureCall() =>
      when(() => fetchSecureCacheStorage.fetch(any()));

  void mockFetchSecure(String? data) {
    mockFetchSecureCall().thenAnswer((_) async => data);
  }

  void mockFetchSecureError() {
    mockFetchSecureCall().thenThrow((_) async => Exception());
  }

  setUp(() {
    fetchSecureCacheStorage = FetchSecureCacheStorageSpy();
    sut = LocalLoadCurrentAccount(
        fetchSecureCacheStorage: fetchSecureCacheStorage);
    token = faker.guid.guid();
    mockFetchSecure(token);
  });

  test('Should call FetchSecureCacheStorage with correct values ...', () async {
    await sut.load();

    verify(() => fetchSecureCacheStorage.fetch('token'));
  });

  test('Should return an AccountEntity ...', () async {
    final account = await sut.load();

    expect(account, AccountEntity(token: token));
  });

  test(
      'Should throw domain UnexpectedError if fetchSecureCacheStorage throws  ...',
      () async {
    mockFetchSecureError();

    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });

  test(
      'Should throw domain UnexpectedError if fetchSecureCacheStorage returns null  ...',
      () async {
    mockFetchSecure(null);

    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });
}
