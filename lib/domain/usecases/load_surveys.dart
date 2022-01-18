import 'package:curso_tdd/domain/entities/entities.dart';

abstract class LoadSurveys {
  Future<List<SurveyEntity>> load();
}
