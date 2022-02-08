import 'package:curso_tdd/domain/entities/entities.dart';
import 'package:curso_tdd/ui/pages/pages.dart';

extension SurveyResultEntityExtensions on SurveyResultEntity {
  SurveysResultViewModel toViewModel() => SurveysResultViewModel(
      question: question,
      surveyId: surveyId,
      answers: answers.map((answer) => answer.toViewModel()).toList());
}

extension SurveyAnswerEntityExtensions on SurveyAnswerEntity {
  SurveyAnswerViewModel toViewModel() => SurveyAnswerViewModel(
      image: image,
      answer: answer,
      percent: '$percent%',
      isCurrentAnswer: isCurrentAnswer);
}
