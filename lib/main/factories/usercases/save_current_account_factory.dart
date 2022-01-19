import 'package:curso_tdd/data/usercases/save_current_account/save_current_account.dart';
import 'package:curso_tdd/domain/usecases/save_current_account.dart';
import 'package:curso_tdd/main/factories/cache/cache.dart';

ISaveCurrentAccount makeLocalSaveCurrentAccount() {
  return LocalSaveCurrentAccount(
      saveSecureCacheStorage: makeSecureStorageAdapter());
}
