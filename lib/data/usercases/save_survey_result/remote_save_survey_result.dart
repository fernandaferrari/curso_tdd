import 'package:curso_tdd/data/http/http.dart';
import 'package:curso_tdd/data/model/model.dart';
import 'package:curso_tdd/domain/entities/entities.dart';
import 'package:curso_tdd/domain/helpers/helpers.dart';
import 'package:curso_tdd/domain/usecases/usecases.dart';
import 'package:meta/meta.dart';

class RemoteSaveSurveyResult implements SaveSurveyResult {
  final IHttpClient httpClient;
  final String url;

  RemoteSaveSurveyResult({
    @required this.httpClient,
    @required this.url,
  });

  Future<SurveyResultEntity> save({String answer}) async {
    try {
      final json = await httpClient
          .request(url: url, method: 'put', body: {'answer': answer});
      return RemoteSurveyResultModel.fromJson(json).toEntity();
    } on HttpError catch (error) {
      throw error == HttpError.forbidden
          ? DomainError.acessDenied
          : DomainError.unexpected;
    }
  }
}
