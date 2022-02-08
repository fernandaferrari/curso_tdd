import 'package:flutter/material.dart';

import 'package:curso_tdd/ui/pages/pages.dart';
import 'package:curso_tdd/ui/pages/survey_result/components/components.dart';

class SurveyResult extends StatelessWidget {
  final SurveysResultViewModel viewModel;
  final void Function({required String answer}) onSave;

  const SurveyResult({Key? key, required this.viewModel, required this.onSave})
      : super(key: key);

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
        final answer = viewModel.answers[index - 1];
        return GestureDetector(
            onTap: () =>
                answer.isCurrentAnswer ? null : onSave(answer: answer.answer),
            child: SurveyAnswer(viewModel: answer));
      },
    );
  }
}
