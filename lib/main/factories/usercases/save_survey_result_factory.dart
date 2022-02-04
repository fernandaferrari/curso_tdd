import 'package:curso_tdd/data/usercases/save_survey_result/save_surveys_result.dart';
import 'package:curso_tdd/domain/usecases/usecases.dart';
import 'package:curso_tdd/main/factories/http/authorize_http_client_decorator_factory.dart';

import '../factories.dart';

SaveSurveyResult makeRemoteSaveSurveyResult(String surveyId) {
  return RemoteSaveSurveyResult(
    httpClient: makeAuthorizeHttpClientDecorator(),
    url: makeApiUrl('surveys/$surveyId/results'),
  );
}
