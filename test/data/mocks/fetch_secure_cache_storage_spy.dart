import 'package:curso_tdd/data/cache/cache.dart';
import 'package:mocktail/mocktail.dart';

class FetchSecureCacheStorageSpy extends Mock
    implements FetchSecureCacheStorage {
  When mockTokenCall() => when(() => fetch(any()));

  void mockToken(String token) {
    mockTokenCall().thenAnswer((_) async => token);
  }

  void mockTokenError() => mockTokenCall().thenThrow(Exception());
}
