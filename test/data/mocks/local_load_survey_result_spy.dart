import 'package:curso_tdd/data/usercases/load_surveys_result/load_surveys_result.dart';
import 'package:curso_tdd/domain/entities/entities.dart';
import 'package:curso_tdd/domain/helpers/helpers.dart';
import 'package:mocktail/mocktail.dart';

class LocalLoadSurveyResultSpy extends Mock implements LocalLoadSurveyResult {
  LocalLoadSurveyResultSpy() {
    mockValidate();
    mockSave();
  }

  When mockLoadResultCall() =>
      when(() => loadBySurvey(surveyId: any(named: 'surveyId')));
  void mockLocalSurveyResult(SurveyResultEntity data) =>
      mockLoadResultCall().thenAnswer((_) async => data);
  void mockLocalError() =>
      mockLoadResultCall().thenThrow(DomainError.unexpected);

  When mockValidateCall() => when(() => validate(any()));
  void mockValidate() => mockValidateCall().thenAnswer((_) async => _);

  When mockSaveCall() =>
      when(() => save(surveyResult: any(named: 'surveyResult')));
  void mockSave() => mockSaveCall().thenAnswer((_) async => _);
}
