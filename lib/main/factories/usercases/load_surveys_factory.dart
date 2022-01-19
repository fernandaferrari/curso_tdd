import 'package:curso_tdd/data/usercases/usecase.dart';
import 'package:curso_tdd/domain/usecases/load_surveys.dart';
import 'package:curso_tdd/main/factories/http/authorize_http_client_decorator_factory.dart';

import '../factories.dart';

LoadSurveys makeRemoteLoadSurveys() {
  return RemoteLoadSurveys(
      httpClient: makeAuthorizeHttpClientDecorator(),
      url: makeApiUrl('surveys'));
}
