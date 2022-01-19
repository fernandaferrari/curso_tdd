import 'package:curso_tdd/ui/pages/surveys/surveys_view_model.dart';

abstract class SurveysPresenter {
  Stream<bool> get isLoadStream;
  Stream<List<SurveysViewModel>> get surveysStream;

  Future<void> loadData();
}
