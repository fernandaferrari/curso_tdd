import 'package:curso_tdd/main/factories/factories.dart';
import 'package:curso_tdd/presentation/presenter/presenter.dart';
import 'package:curso_tdd/ui/pages/pages.dart';

SurveyResultPresenter makeGetxSurveyResultPresenter(String surveyId) =>
    GetxSurveyResultPresenter(
        loadSurveyResultStream:
            makeRemoteLoadSurveyResultWithLocalFallback(surveyId),
        saveSurveyResult: makeRemoteSaveSurveyResult(surveyId),
        surveyId: surveyId);
