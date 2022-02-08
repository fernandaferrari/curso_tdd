import 'package:curso_tdd/main/factories/usercases/usecases.dart';
import 'package:curso_tdd/presentation/presenter/presenter.dart';
import 'package:curso_tdd/ui/pages/surveys/surveys.dart';
import 'package:flutter/material.dart';

Widget makeSurveysPage() => SurveysPage(
      GetxSurveysPresenter(
          loadSurveysStream: makeRemoteLoadSurveysWithLocalFallback()),
    );
