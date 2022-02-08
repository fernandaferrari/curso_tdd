import 'package:curso_tdd/data/cache/cache.dart';
import 'package:mocktail/mocktail.dart';

class SaveSecureCacheStorageSpy extends Mock implements SaveSecureCacheStorage {
  SaveSecureCacheStorageSpy() {
    mockSave();
  }

  When mockSaveCall() =>
      when(() => save(key: any(named: 'key'), value: any(named: 'value')));

  void mockSave() => mockSaveCall().thenAnswer((_) async => _);
  void mockSaveError() => mockSaveCall().thenThrow(Exception());
}
