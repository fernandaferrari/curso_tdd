import 'package:curso_tdd/ui/pages/pages.dart';

abstract class SurveyResultPresenter {
  Stream<bool> get isLoadStream;
  Stream<SurveysResultViewModel> get surveysResultStream;

  Future<void> loadData();
}
