import 'package:curso_tdd/ui/pages/pages.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class SurveyItem extends StatelessWidget {
  final SurveysViewModel viewModel;
  const SurveyItem({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<SurveysPresenter>(context);
    return GestureDetector(
      onTap: () => presenter.goToSurveyResult(viewModel.id),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: viewModel.didAnswer
                  ? Theme.of(context).secondaryHeaderColor
                  : Theme.of(context).primaryColorDark,
              boxShadow: const [
                BoxShadow(
                    offset: Offset(0, 1),
                    spreadRadius: 0,
                    blurRadius: 3,
                    color: Colors.black)
              ],
              borderRadius: const BorderRadius.all(Radius.circular(10))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(viewModel.date,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              Text(viewModel.question,
                  style: TextStyle(color: Colors.white, fontSize: 20))
            ],
          ),
        ),
      ),
    );
  }
}
