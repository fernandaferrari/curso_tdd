import 'package:localstorage/localstorage.dart';
import 'package:mocktail/mocktail.dart';

class LocalStorageSpy extends Mock implements LocalStorage {
  LocalStorageSpy() {
    mockReady();
    mockDelete();
    mockSave();
  }

  When mockDeleteCall() => when(() => deleteItem(any()));
  void mockDelete() => this.mockDeleteCall().thenAnswer((_) async => _);
  void mockDeleteError() =>
      when(() => this.mockDeleteCall().thenThrow(Exception()));

  When mockSaveCall() => when(() => setItem(any(), any()));
  void mockSave() => this.mockSaveCall().thenAnswer((_) async => _);
  void mockSaveError() =>
      when(() => this.mockSaveCall().thenThrow(Exception()));

  When mockFetchCall() => when(() => getItem(any()));
  void mockFetch(dynamic data) =>
      this.mockFetchCall().thenAnswer((_) async => data);
  void mockFetchError() => when(() => mockFetchCall().thenThrow(Exception()));

  When mockReadyCall() => when(() => ready);
  void mockReady() => mockReadyCall().thenAnswer((_) async => true);
}
