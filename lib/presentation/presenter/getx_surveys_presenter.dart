import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

import 'package:curso_tdd/ui/helpers/errors/ui_error.dart';
import 'package:curso_tdd/ui/pages/surveys/surveys_presenter.dart';
import 'package:curso_tdd/ui/pages/surveys/surveys_view_model.dart';

import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';

class GetxSurveysPresenter extends GetxController implements SurveysPresenter {
  final LoadSurveys loadSurveysStream;

  GetxSurveysPresenter({
    @required this.loadSurveysStream,
  });

  final _isLoad = true.obs;
  final _surveys = Rx<List<SurveysViewModel>>();

  Stream<bool> get isLoadStream => _isLoad.stream;
  Stream<List<SurveysViewModel>> get surveysStream => _surveys.stream;

  Future<void> loadData() async {
    try {
      _isLoad.value = true;
      final surveys = await loadSurveysStream.load();
      _surveys.value = surveys
          .map((surveys) => SurveysViewModel(
              id: surveys.id,
              question: surveys.question,
              date: DateFormat('dd MMM yyyy').format(surveys.dateTime),
              didAnswer: surveys.didAnswer))
          .toList();
    } on DomainError {
      _surveys.subject.addError(UIError.unexpected.description);
    } finally {
      _isLoad.value = false;
    }
  }
}
