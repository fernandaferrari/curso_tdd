import 'package:curso_tdd/data/usercases/usecase.dart';
import 'package:curso_tdd/domain/usecases/load_current_account.dart';
import 'package:curso_tdd/main/factories/cache/cache.dart';

LoadCurrentAccount makeLocalLoadCurrentAccount() {
  return LocalLoadCurrentAccount(
    fetchSecureCacheStorage: makeLocalStorageAdapter(),
  );
}
