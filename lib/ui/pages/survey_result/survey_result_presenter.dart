import 'package:curso_tdd/data/model/model.dart';

abstract class SurveyResultPresenter {
  Stream<bool> get isLoadStream;
  Stream<RemoteSurveyResultModel> get surveysStream;

  Future<void> loadData();
}
