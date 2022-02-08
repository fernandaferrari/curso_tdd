import 'package:curso_tdd/data/cache/cache.dart';
import 'package:curso_tdd/data/model/model.dart';
import 'package:curso_tdd/domain/entities/entities.dart';
import 'package:curso_tdd/domain/helpers/helpers.dart';
import 'package:curso_tdd/domain/usecases/load_survey_result.dart';

class LocalLoadSurveyResult implements LoadSurveyResult {
  final CacheStorage cacheStorage;
  LocalLoadSurveyResult({
    required this.cacheStorage,
  });

  @override
  Future<SurveyResultEntity> loadBySurvey({required String surveyId}) async {
    try {
      final json = await cacheStorage.fetch('survey_result/$surveyId');
      if (json?.isEmpty != false) {
        throw Exception();
      }
      return LocalSurveyResultModel.fromJson(json).toEntity();
    } catch (error) {
      throw DomainError.unexpected;
    }
  }

  Future<void> validate(String surveyId) async {
    try {
      final json = await cacheStorage.fetch('survey_result/$surveyId');
      LocalSurveyResultModel.fromJson(json).toEntity();
    } catch (error) {
      await cacheStorage.delete('survey_result/$surveyId');
    }
  }

  Future<void> save({required SurveyResultEntity surveyResult}) async {
    try {
      final json = LocalSurveyResultModel.fromEntity(surveyResult).toJson();

      await cacheStorage.save(
          key: "survey_result/${surveyResult.surveyId}", value: json);
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}
