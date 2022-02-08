import 'package:curso_tdd/data/cache/cache.dart';
import 'package:mocktail/mocktail.dart';

class DeleteSecureCacheStorageSpy extends Mock
    implements DeleteSecureCacheStorage {
  DeleteSecureCacheStorageSpy() {
    when(() => delete(any())).thenAnswer((_) async => _);
  }
}
