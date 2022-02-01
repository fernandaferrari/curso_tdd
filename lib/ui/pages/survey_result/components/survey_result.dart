import 'package:curso_tdd/ui/pages/pages.dart';
import 'package:curso_tdd/ui/pages/survey_result/components/components.dart';
import 'package:flutter/material.dart';

class SurveyResult extends StatelessWidget {
  final SurveysResultViewModel data;

  const SurveyResult({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: data.answers.length + 1,
      itemBuilder: (ctx, index) {
        if (index == 0) {
          return Container(
            padding: EdgeInsets.only(top: 40, bottom: 20, left: 20, right: 20),
            decoration: BoxDecoration(
                color: Theme.of(context).disabledColor.withAlpha(80)),
            child: Text(
              data.question,
              style: TextStyle(fontSize: 18),
            ),
          );
        }
        return Column(
          children: [
            Container(
              padding: EdgeInsets.all(15),
              decoration:
                  BoxDecoration(color: Theme.of(context).backgroundColor),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  data.answers[index - 1].image != null
                      ? Image.network(
                          data.answers[index - 1].image,
                          width: 40,
                        )
                      : SizedBox(
                          height: 0,
                        ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        data.answers[index - 1].answer,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  Text(data.answers[index - 1].percent,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColorDark)),
                  data.answers[index - 1].isCurrentAnswer
                      ? ActiveIcon()
                      : DisableIcon(),
                ],
              ),
            ),
            Divider(
              height: 1,
            )
          ],
        );
      },
    );
  }
}
