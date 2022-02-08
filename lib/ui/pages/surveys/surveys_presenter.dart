import 'package:curso_tdd/ui/pages/surveys/surveys_view_model.dart';
import 'package:flutter/material.dart';

abstract class SurveysPresenter implements Listenable {
  Stream<bool> get isLoadStream;
  Stream<List<SurveysViewModel>> get surveysStream;
  Stream<String?> get navigateToStream;
  Stream<bool> get isSessionExpiredStream;

  Future<void> loadData();
  void goToSurveyResult(String id);
}
