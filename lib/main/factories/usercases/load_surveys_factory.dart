import 'package:curso_tdd/data/usercases/usecase.dart';
import 'package:curso_tdd/domain/usecases/load_surveys.dart';
import 'package:curso_tdd/main/composites/composites.dart';
import 'package:curso_tdd/main/factories/http/authorize_http_client_decorator_factory.dart';

import '../factories.dart';

RemoteLoadSurveys makeRemoteLoadSurveys() {
  return RemoteLoadSurveys(
      httpClient: makeAuthorizeHttpClientDecorator(),
      url: makeApiUrl('surveys'));
}

LocalLoadSurveys makeLocalLoadSurveys() {
  return LocalLoadSurveys(cacheStorage: makeLocalStorageAdapter());
}

LoadSurveys makeRemoteLoadSurveysWithLocalFallback() {
  return RemoteLoadSurveysWithLocalFallback(
      remote: makeRemoteLoadSurveys(), local: makeLocalLoadSurveys());
}
