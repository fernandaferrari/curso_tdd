import 'package:curso_tdd/domain/entities/entities.dart';
import 'package:meta/meta.dart';

class LocalSurveyResultModel {
  final String surveyId;
  final String question;
  final List<LocalSurveyAnswerModel> answers;

  LocalSurveyResultModel({
    @required this.surveyId,
    @required this.question,
    @required this.answers,
  });

  factory LocalSurveyResultModel.fromJson(Map json) {
    if (!json.keys.toSet().containsAll(['surveyId', 'question', 'answers'])) {
      throw Exception();
    }
    return LocalSurveyResultModel(
        surveyId: json['surveyId'],
        question: json['question'],
        answers: json['answers']
            .map<LocalSurveyAnswerModel>(
                (answerJson) => LocalSurveyAnswerModel.fromJson(answerJson))
            .toList());
  }

  SurveyResultEntity toEntity() => SurveyResultEntity(
        surveyId: surveyId,
        question: question,
        answers: answers
            .map<SurveyAnswerEntity>((answer) => answer.toEntity())
            .toList(),
      );

  factory LocalSurveyResultModel.fromEntity(SurveyResultEntity entity) =>
      LocalSurveyResultModel(
          surveyId: entity.surveyId,
          question: entity.question,
          answers: entity.answers
              .map<LocalSurveyAnswerModel>(
                  (answer) => LocalSurveyAnswerModel.fromEntity(answer))
              .toList());

  Map toJson() => {
        'surveyId': surveyId,
        'question': question,
        'answers': answers.map<Map>((answer) => answer.toJson()).toList()
      };
}

class LocalSurveyAnswerModel {
  final String image;
  final String answer;
  final bool isCurrentAnswer;
  final int percent;
  LocalSurveyAnswerModel({
    this.image,
    @required this.answer,
    @required this.isCurrentAnswer,
    @required this.percent,
  });

  factory LocalSurveyAnswerModel.fromJson(Map json) {
    if (!json.keys
        .toSet()
        .containsAll(['answer', 'isCurrentAnswer', 'percent'])) {
      throw Exception();
    }
    return LocalSurveyAnswerModel(
        image: json['image'],
        answer: json['answer'],
        isCurrentAnswer: json['isCurrentAnswer'].toLowerCase() == 'true',
        percent: int.parse(json['percent']));
  }

  SurveyAnswerEntity toEntity() => SurveyAnswerEntity(
      image: image,
      answer: answer,
      isCurrentAnswer: isCurrentAnswer,
      percent: percent);

  factory LocalSurveyAnswerModel.fromEntity(SurveyAnswerEntity entity) =>
      LocalSurveyAnswerModel(
          image: entity.image,
          answer: entity.answer,
          isCurrentAnswer: entity.isCurrentAnswer,
          percent: entity.percent);

  Map toJson() => {
        'image': image,
        'answer': answer,
        'percent': percent.toString(),
        'isCurrentAnswer': isCurrentAnswer.toString()
      };
}
