import 'package:curso_tdd/data/cache/cache.dart';
import 'package:curso_tdd/domain/entities/entities.dart';
import 'package:curso_tdd/domain/helpers/helpers.dart';
import 'package:curso_tdd/domain/usecases/usecases.dart';

class LocalLoadCurrentAccount implements LoadCurrentAccount {
  FetchSecureCacheStorage fetchSecureCacheStorage;

  LocalLoadCurrentAccount({required this.fetchSecureCacheStorage});

  Future<AccountEntity> load() async {
    try {
      final token = await fetchSecureCacheStorage.fetch('token');
      if (token == null) throw Error();
      return AccountEntity(token: token);
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}
