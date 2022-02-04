import 'package:curso_tdd/data/usercases/load_surveys_result/load_surveys_result.dart';
import 'package:curso_tdd/domain/usecases/usecases.dart';
import 'package:curso_tdd/main/composites/composites.dart';
import 'package:curso_tdd/main/factories/http/authorize_http_client_decorator_factory.dart';

import '../factories.dart';

LoadSurveyResult makeRemoteLoadSurveyResult(String surveyId) {
  return RemoteLoadSurveysResult(
    httpClient: makeAuthorizeHttpClientDecorator(),
    url: makeApiUrl('surveys/$surveyId/results'),
  );
}

LoadSurveyResult makeLoadLoadSurveyResult(String surveyId) {
  return LocalLoadSurveyResult(cacheStorage: makeLocalStorageAdapter());
}

LoadSurveyResult makeRemoteLoadSurveyResultWithLocalFallback(String surveyId) {
  return RemoteLoadSurveyResultWithLocalFallback(
      local: makeLoadLoadSurveyResult(surveyId),
      remote: makeRemoteLoadSurveyResult(surveyId));
}
