import 'package:curso_tdd/domain/entities/survey_entity.dart';

abstract class LoadSurveys {
  Future<List<SurveyEntity>> load();
}
