import 'package:curso_tdd/data/usercases/load_surveys_result/load_surveys_result.dart';
import 'package:curso_tdd/domain/entities/entities.dart';
import 'package:curso_tdd/domain/helpers/helpers.dart';
import 'package:mocktail/mocktail.dart';

class RemoteLoadSurveysResultSpy extends Mock
    implements RemoteLoadSurveysResult {
  When mockRemoteResultCall() =>
      when(() => loadBySurvey(surveyId: any(named: 'surveyId')));
  void mockSurveyResult(SurveyResultEntity data) =>
      mockRemoteResultCall().thenAnswer((_) async => data);
  void mockRemoteError(DomainError error) =>
      mockRemoteResultCall().thenThrow(error);
}
