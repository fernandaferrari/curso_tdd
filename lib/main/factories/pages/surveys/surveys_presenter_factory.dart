import 'package:curso_tdd/main/factories/factories.dart';
import 'package:curso_tdd/presentation/presenter/getx_surveys_presenter.dart';
import 'package:curso_tdd/ui/pages/surveys/surveys_presenter.dart';

SurveysPresenter makeGetxSurveysPresenter() =>
    GetxSurveysPresenter(loadSurveysStream: makeRemoteLoadSurveys());
