import 'package:curso_tdd/data/model/model.dart';

import '../../domain/entities/entities.dart';
import '../http/http.dart';
import 'package:meta/meta.dart';

class RemoteSurveyResultModel {
  final String surveyId;
  final String question;
  final List<RemoteSurveyAnswerModel> asnwers;

  RemoteSurveyResultModel({
    @required this.surveyId,
    @required this.question,
    @required this.asnwers,
  });

  factory RemoteSurveyResultModel.fromJson(Map json) {
    if (!json.keys.toSet().containsAll(['surveyId', 'question', 'answers'])) {
      throw HttpError.invalidData;
    }
    return RemoteSurveyResultModel(
        surveyId: json['surveyId'],
        question: json['question'],
        asnwers: json['answers']
            .map<RemoteSurveyAnswerModel>(
                (answerJson) => RemoteSurveyAnswerModel.fromJson(answerJson))
            .toList());
  }

  SurveyResultEntity toEntity() => SurveyResultEntity(
      surveyId: surveyId,
      question: question,
      answers: asnwers
          .map<SurveyAnswerEntity>((answer) => answer.toEntity())
          .toList());
}
