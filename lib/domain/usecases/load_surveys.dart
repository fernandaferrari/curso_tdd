import 'package:curso_tdd/domain/entities/survey_entity.dart';
import 'package:curso_tdd/ui/pages/surveys/surveys_view_model.dart';

abstract class LoadSurveys {
  Future<List<SurveyEntity>> load();
}
