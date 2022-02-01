import 'package:curso_tdd/ui/components/components.dart';
import 'package:curso_tdd/ui/pages/survey_result/survey_result_presenter.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'package:curso_tdd/ui/helpers/helpers.dart';

class SurveyResultPage extends StatelessWidget {
  final SurveyResultPresenter presenter;

  const SurveyResultPage({Key key, @required this.presenter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(R.strings.surveys)),
      ),
      body: Builder(builder: (ctx) {
        presenter.isLoadStream.listen((isLoading) {
          if (isLoading == true) {
            showLoading(context);
          } else {
            hideLoading(context);
          }
        });

        presenter.loadData();

        return StreamBuilder<dynamic>(
            stream: presenter.surveysResultStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return ReloadScreen(
                  error: snapshot.error,
                  reload: presenter.loadData,
                );
              }

              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: 4,
                  itemBuilder: (ctx, index) {
                    if (index == 0) {
                      return Container(
                        padding: EdgeInsets.only(
                            top: 40, bottom: 20, left: 20, right: 20),
                        decoration: BoxDecoration(
                            color:
                                Theme.of(context).disabledColor.withAlpha(80)),
                        child: Text(
                          "Qual é seu framework preferido?",
                          style: TextStyle(fontSize: 18),
                        ),
                      );
                    }
                    return Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              color: Theme.of(context).backgroundColor),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.network(
                                'https://fordevs.herokuapp.com/static/img/logo-angular.png',
                                width: 40,
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Text(
                                    "Angular",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                              Text("100%",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          Theme.of(context).primaryColorDark)),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Icon(
                                  Icons.check_circle,
                                  color: Theme.of(context).highlightColor,
                                ),
                              ),
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
              return SizedBox(height: 0);
            });
      }),
    );
  }
}
