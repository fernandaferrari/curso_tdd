import 'dart:async';

import 'package:curso_tdd/ui/pages/pages.dart';
import 'package:mocktail/mocktail.dart';

class SurveysPresenterSpy extends Mock implements SurveysPresenter {
  final isLoadController = StreamController<bool>();
  final loadSurveysController = StreamController<List<SurveysViewModel>>();
  final navigateToController = StreamController<String?>();
  final isSessionExpiredController = StreamController<bool>();

  SurveysPresenterSpy() {
    when(() => loadData()).thenAnswer((_) async => _);
    when(() => isLoadStream).thenAnswer((_) => isLoadController.stream);
    when(() => surveysStream).thenAnswer((_) => loadSurveysController.stream);
    when(() => navigateToStream).thenAnswer((_) => navigateToController.stream);
    when(() => isSessionExpiredStream)
        .thenAnswer((_) => isSessionExpiredController.stream);
  }

  void emitSurveys(List<SurveysViewModel> data) =>
      loadSurveysController.add(data);
  void emitSurveysError(String error) => loadSurveysController.addError(error);
  void emitLoading([bool show = true]) => isLoadController.add(show);
  void emitSessionExpired([bool show = true]) =>
      isSessionExpiredController.add(show);
  void emitNavigateTo(String route) => navigateToController.add(route);

  void dispose() {
    isLoadController.close();
    loadSurveysController.close();
    navigateToController.close();
    isSessionExpiredController.close();
  }
}
