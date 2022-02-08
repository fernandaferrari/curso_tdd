import 'package:curso_tdd/domain/entities/entities.dart';

abstract class SaveSurveyResult {
  Future<SurveyResultEntity> save({required String answer});
}
