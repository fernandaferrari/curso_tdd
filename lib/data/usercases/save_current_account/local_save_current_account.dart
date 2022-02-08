import 'package:curso_tdd/data/cache/cache.dart';
import 'package:curso_tdd/domain/entities/entities.dart';
import 'package:curso_tdd/domain/helpers/helpers.dart';
import 'package:curso_tdd/domain/usecases/usecases.dart';

class LocalSaveCurrentAccount implements ISaveCurrentAccount {
  SaveSecureCacheStorage saveSecureCacheStorage;

  LocalSaveCurrentAccount({required this.saveSecureCacheStorage});

  @override
  Future<void> save(AccountEntity account) async {
    try {
      await saveSecureCacheStorage.save(key: 'token', value: account.token);
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}
