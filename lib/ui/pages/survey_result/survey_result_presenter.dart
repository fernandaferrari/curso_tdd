import 'package:curso_tdd/ui/pages/pages.dart';
import 'package:flutter/material.dart';

abstract class SurveyResultPresenter implements Listenable {
  Stream<bool> get isLoadStream;
  Stream<SurveysResultViewModel?> get surveysResultStream;
  Stream<bool> get isSessionExpiredStream;

  Future<void> loadData();
  Future<void> save({required String answer});
}
