import 'dart:async';

import 'package:curso_tdd/ui/pages/pages.dart';
import 'package:mocktail/mocktail.dart';

class SurveyResultPresenterSpy extends Mock implements SurveyResultPresenter {
  final isLoadController = StreamController<bool>();
  final surveyResultController = StreamController<SurveysResultViewModel>();
  final isSessionExpiredController = StreamController<bool>();

  SurveyResultPresenterSpy() {
    when(() => save(answer: any(named: 'answer'))).thenAnswer((_) async => _);
    when(() => loadData()).thenAnswer((_) async => _);
    when(() => isLoadStream).thenAnswer((_) => isLoadController.stream);
    when(() => surveysResultStream)
        .thenAnswer((_) => surveyResultController.stream);
    when(() => isSessionExpiredStream)
        .thenAnswer((_) => isSessionExpiredController.stream);
  }

  void emitSurveyResult(SurveysResultViewModel data) =>
      surveyResultController.add(data);
  void emitSurveyResultError(String error) =>
      surveyResultController.addError(error);
  void emitLoading([bool show = true]) => isLoadController.add(show);
  void emitSessionExpired([bool show = true]) =>
      isSessionExpiredController.add(show);

  void dispose() {
    isLoadController.close();
    surveyResultController.close();
    isSessionExpiredController.close();
  }
}
