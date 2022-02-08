import 'package:curso_tdd/data/usercases/usecase.dart';
import 'package:curso_tdd/domain/entities/entities.dart';
import 'package:curso_tdd/domain/helpers/helpers.dart';
import 'package:mocktail/mocktail.dart';

class LocalLoadSurveysSpy extends Mock implements LocalLoadSurveys {
  LocalLoadSurveysSpy() {
    mockValidate();
    mockSave();
  }

  When mockLoadCall() => when(() => load());
  void mockLocalLoad(List<SurveyEntity> data) =>
      mockLoadCall().thenAnswer((_) async => data);
  void mockLocalLoadError() => mockLoadCall().thenThrow(DomainError.unexpected);

  When mockValidateCall() => when(() => validate());
  void mockValidate() => mockValidateCall().thenAnswer((_) async => _);

  When mockSaveCall() => when(() => save(any()));
  void mockSave() => mockSaveCall().thenAnswer((_) async => _);
}
