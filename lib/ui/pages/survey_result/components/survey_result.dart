import 'package:flutter/material.dart';

import 'package:curso_tdd/ui/pages/pages.dart';
import 'package:curso_tdd/ui/pages/survey_result/components/components.dart';

class SurveyResult extends StatelessWidget {
  final SurveysResultViewModel viewModel;

  const SurveyResult({Key key, this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: viewModel.answers.length + 1,
      itemBuilder: (ctx, index) {
        if (index == 0) {
          return SurveyHeader(
            question: viewModel.question,
          );
        }
        return SurveyAnswer(viewModel: viewModel.answers[index - 1]);
      },
    );
  }
}
