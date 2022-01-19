import 'package:curso_tdd/data/usercases/usecase.dart';
import 'package:curso_tdd/domain/usecases/load_surveys.dart';

import '../factories.dart';

LoadSurveys makeRemoteLoadSurveys() {
  return RemoteLoadSurveys(
      httpClient: makeHttpAdapter(), url: makeApiUrl('surveys'));
}
