import 'package:curso_tdd/domain/helpers/helpers.dart';
import 'package:curso_tdd/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class SaveCurrentAccountSpy extends Mock implements ISaveCurrentAccount {
  SaveCurrentAccountSpy() {
    mockSave();
  }

  When mockSaveCall() => when(() => save(any()));
  void mockSave() => this.mockSaveCall().thenAnswer((_) async => _);
  void mockSaveError() => this.mockSaveCall().thenThrow(DomainError.unexpected);
}
