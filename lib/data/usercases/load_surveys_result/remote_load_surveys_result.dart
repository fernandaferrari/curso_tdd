import 'package:curso_tdd/data/http/http.dart';
import 'package:curso_tdd/data/model/model.dart';
import 'package:curso_tdd/domain/entities/entities.dart';
import 'package:curso_tdd/domain/helpers/helpers.dart';
import 'package:curso_tdd/domain/usecases/usecases.dart';

class RemoteLoadSurveysResult implements LoadSurveyResult {
  final String url;
  final IHttpClient httpClient;

  RemoteLoadSurveysResult({
    required this.url,
    required this.httpClient,
  });

  Future<SurveyResultEntity> loadBySurvey({required String surveyId}) async {
    try {
      final json = await httpClient.request(url: url, method: 'get');
      return RemoteSurveyResultModel.fromJson(json).toEntity();
    } on HttpError catch (error) {
      throw error == HttpError.forbidden
          ? DomainError.acessDenied
          : DomainError.unexpected;
    }
  }
}
