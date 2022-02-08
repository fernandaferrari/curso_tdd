import 'package:curso_tdd/data/usercases/save_current_account/save_current_account.dart';
import 'package:curso_tdd/domain/entities/account_entity.dart';
import 'package:curso_tdd/domain/helpers/helpers.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/mocks.dart';

void main() {
  late SaveSecureCacheStorageSpy cacheStorage;
  late LocalSaveCurrentAccount sut;
  late AccountEntity account;

  setUp(() {
    cacheStorage = SaveSecureCacheStorageSpy();
    sut = LocalSaveCurrentAccount(saveSecureCacheStorage: cacheStorage);
    account = AccountEntity(token: faker.guid.guid());
  });

  test('Should call SaveSecureCacheStorage with correct values', () async {
    await sut.save(account);
    verify(() => cacheStorage.save(key: 'token', value: account.token));
  });

  test('Should throw UnexpectedError SaveSecureCacheStorage throws', () async {
    cacheStorage.mockSaveError();
    final future = sut.save(account);

    expect(future, throwsA(DomainError.unexpected));
  });
}
