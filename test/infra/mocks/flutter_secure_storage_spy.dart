import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mocktail/mocktail.dart';

class FlutterSecureStorageSpy extends Mock implements FlutterSecureStorage {
  FlutterSecureStorageSpy() {
    mockSave();
    mockDelete();
  }

  When mockSaveCall() =>
      when(() => write(key: any(named: 'key'), value: any(named: 'value')));
  void mockSave() => mockSaveCall().thenAnswer((_) async => _);
  void mockSaveSecureError() => mockSaveCall().thenThrow(Exception());

  When mockFetchSecureCall() => when(() => read(key: any(named: 'key')));
  void mockFetchSecure(String? value) =>
      mockFetchSecureCall().thenAnswer((_) async => value);
  void mockFetchSecureError() => mockFetchSecureCall().thenThrow(Exception());

  When mockDeleteCall() => when(() => delete(key: any(named: 'key')));
  void mockDelete() => mockDeleteCall().thenAnswer((_) async => _);
  void mockDeleteSecureError() => mockDeleteCall().thenThrow(Exception());
}
