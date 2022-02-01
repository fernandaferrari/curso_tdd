import 'package:curso_tdd/domain/entities/entities.dart';
import 'package:meta/meta.dart';

class SurveyResultEntity {
  final String surveyId;
  final String question;
  final List<SurveyAnswerEntity> answer;

  SurveyResultEntity({
    @required this.surveyId,
    @required this.question,
    @required this.answer,
  });
}
