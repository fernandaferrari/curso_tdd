import 'package:curso_tdd/domain/entities/entities.dart';
import 'package:meta/meta.dart';

abstract class LoadSurveyResult {
  Future<SurveyResultEntity> loadBySurvey({String surveyId});
}
