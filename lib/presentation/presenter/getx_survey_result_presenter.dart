import 'package:curso_tdd/presentation/mixins/mixins.dart';
import 'package:curso_tdd/ui/pages/pages.dart';
import 'package:get/get.dart';
import 'package:meta/meta.dart';

import 'package:curso_tdd/ui/helpers/errors/ui_error.dart';

import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';

class GetxSurveyResultPresenter extends GetxController
    with LoadingManager, SessionManager
    implements SurveyResultPresenter {
  final LoadSurveyResult loadSurveyResultStream;
  final String surveyId;

  GetxSurveyResultPresenter(
      {@required this.loadSurveyResultStream, @required this.surveyId});

  final _surveysResult = Rx<SurveysResultViewModel>();

  Stream<SurveysResultViewModel> get surveysResultStream =>
      _surveysResult.stream;

  Future<void> loadData() async {
    try {
      isLoading = true;
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
    } on DomainError catch (error) {
      if (error == DomainError.acessDenied) {
        isSessionExpired = true;
      } else {
        _surveysResult.subject.addError(UIError.unexpected.description);
      }
    } finally {
      isLoading = false;
    }
  }

  @override
  Future<void> save({@required String answer}) async {
    // TODO: implement save
    throw UnimplementedError();
  }
}
