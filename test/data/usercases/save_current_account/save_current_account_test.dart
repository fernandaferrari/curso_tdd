import 'package:curso_tdd/domain/entities/account_entity.dart';
import 'package:curso_tdd/domain/helpers/helpers.dart';
import 'package:curso_tdd/domain/usecases/usecases.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:meta/meta.dart';

class LocalSaveCurrentAccount implements ISaveCurrentAccount {
  SaveSecureCacheStorage saveSecureCacheStorage;

  LocalSaveCurrentAccount({@required this.saveSecureCacheStorage});

  @override
  Future<void> save(AccountEntity account) async {
    try {
      await saveSecureCacheStorage.saveSecure(
          key: 'token', value: account.token);
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}

abstract class SaveSecureCacheStorage {
  Future<void> saveSecure({@required String key, @required String value});
}

class SaveSecureCacheStorageSpy extends Mock implements SaveSecureCacheStorage {
}

void main() {
  SaveSecureCacheStorageSpy cacheStorage;
  LocalSaveCurrentAccount sut;
  AccountEntity account;

  setUp(() {
    cacheStorage = SaveSecureCacheStorageSpy();
    sut = LocalSaveCurrentAccount(saveSecureCacheStorage: cacheStorage);
    account = AccountEntity(faker.guid.guid());
  });

  test('Should call SaveSecureCacheStorage with correct values', () async {
    await sut.save(account);
    verify(cacheStorage.saveSecure(key: 'token', value: account.token));
  });

  test('Should throw UnexpectedError SaveSecureCacheStorage throws', () async {
    when(cacheStorage.saveSecure(
            key: anyNamed('key'), value: anyNamed('value')))
        .thenThrow(Exception());

    final future = sut.save(account);

    expect(future, throwsA(DomainError.unexpected));
  });
}
