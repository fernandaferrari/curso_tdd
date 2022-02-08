import 'package:curso_tdd/domain/entities/entities.dart';
import 'package:curso_tdd/presentation/mixins/mixins.dart';
import 'package:curso_tdd/ui/pages/pages.dart';
import 'package:get/get.dart';

import 'package:curso_tdd/ui/helpers/errors/ui_error.dart';
import 'helpers/survey_result_entity_extensions.dart';

import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';

class GetxSurveyResultPresenter extends GetxController
    with LoadingManager, SessionManager
    implements SurveyResultPresenter {
  final LoadSurveyResult loadSurveyResultStream;
  final SaveSurveyResult saveSurveyResult;
  final String surveyId;

  GetxSurveyResultPresenter(
      {required this.loadSurveyResultStream,
      required this.saveSurveyResult,
      required this.surveyId});

  final _surveysResult = Rx<SurveysResultViewModel?>(null);

  Stream<SurveysResultViewModel?> get surveysResultStream =>
      _surveysResult.stream;

  Future<void> loadData() async {
    showResultOnAction(
        () => loadSurveyResultStream.loadBySurvey(surveyId: surveyId));
  }

  @override
  Future<void> save({required String answer}) async {
    showResultOnAction(() => saveSurveyResult.save(answer: answer));
  }

  Future<void> showResultOnAction(Future<SurveyResultEntity> action()) async {
    try {
      isLoading = true;
      final surveyResult = await action();
      _surveysResult.subject.add(surveyResult.toViewModel());
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
}
