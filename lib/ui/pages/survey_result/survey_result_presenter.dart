import 'package:curso_tdd/data/model/model.dart';

abstract class SurveyResultPresenter {
  Stream<bool> get isLoadStream;
  Stream<dynamic> get surveysResultStream;

  Future<void> loadData();
}
