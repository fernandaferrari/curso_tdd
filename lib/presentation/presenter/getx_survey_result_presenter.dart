import 'package:curso_tdd/ui/pages/pages.dart';
import 'package:get/get.dart';
import 'package:meta/meta.dart';

import 'package:curso_tdd/ui/helpers/errors/ui_error.dart';

import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';

class GetxSurveyResultPresenter extends GetxController
    implements SurveyResultPresenter {
  final LoadSurveyResult loadSurveyResultStream;
  final String surveyId;

  GetxSurveyResultPresenter(
      {@required this.loadSurveyResultStream, @required this.surveyId});

  final _isLoad = true.obs;
  final _surveysResult = Rx<SurveysResultViewModel>();
  final _isSessionExpired = RxBool();

  Stream<bool> get isLoadStream => _isLoad.stream;
  Stream<SurveysResultViewModel> get surveysResultStream =>
      _surveysResult.stream;
  Stream<bool> get isSessionExpiredStream => _isSessionExpired.stream;

  Future<void> loadData() async {
    try {
      _isLoad.value = true;
      final surveyResult =
          await loadSurveyResultStream.loadBySurvey(surveyId: surveyId);
      _surveysResult.value = SurveysResultViewModel(
          question: surveyResult.question,
          surveyId: surveyResult.surveyId,
          answers: surveyResult.answers
              .map((answer) => SurveyAnswerViewModel(
                  image: answer.image,
                  answer: answer.answer,
                  isCurrentAnswer: answer.isCurrentAnswer,
                  percent: '${answer.percent}'))
              .toList());
    } on DomainError {
      _surveysResult.subject.addError(UIError.unexpected.description);
    } finally {
      _isLoad.value = false;
    }
  }
}
