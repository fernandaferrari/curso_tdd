import 'package:curso_tdd/data/usercases/load_surveys_result/load_surveys_result.dart';
import 'package:curso_tdd/data/usercases/usecase.dart';
import 'package:curso_tdd/domain/usecases/load_survey_result.dart';
import 'package:curso_tdd/main/factories/http/authorize_http_client_decorator_factory.dart';

import '../factories.dart';

LoadSurveyResult makeLoadSurveyResult(String surveyId) {
  return RemoteLoadSurveysResult(
    httpClient: makeAuthorizeHttpClientDecorator(),
    url: makeApiUrl('surveys/$surveyId/results'),
  );
}
