import 'package:curso_tdd/main/factories/factories.dart';
import 'package:curso_tdd/ui/pages/pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget makeSurveyResultPage() => SurveyResultPage(
      presenter: makeGetxSurveyResultPresenter(Get.parameters['survey_id']),
    );
