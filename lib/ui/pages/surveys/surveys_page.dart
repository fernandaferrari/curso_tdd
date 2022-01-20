import 'package:carousel_slider/carousel_slider.dart';
import 'package:curso_tdd/ui/components/components.dart';
import 'package:curso_tdd/ui/pages/surveys/surveys_view_model.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'package:curso_tdd/ui/helpers/helpers.dart';
import 'package:curso_tdd/ui/pages/surveys/components/components.dart';
import 'package:curso_tdd/ui/pages/surveys/surveys_presenter.dart';

class SurveysPage extends StatelessWidget {
  final SurveysPresenter presenter;
  const SurveysPage({
    Key key,
    @required this.presenter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(R.strings.surveys)),
      ),
      body: Builder(builder: (context) {
        presenter.isLoadStream.listen((isLoading) {
          if (isLoading == true) {
            showLoading(context);
          } else {
            hideLoading(context);
          }
        });

        presenter.loadData();
        return StreamBuilder<List<SurveysViewModel>>(
            stream: presenter.surveysStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Padding(
                  padding: const EdgeInsets.all(40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        snapshot.error,
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10),
                      RaisedButton(
                        onPressed: presenter.loadData,
                        child: Text(R.strings.reload),
                      )
                    ],
                  ),
                );
              }

              if (snapshot.hasData) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: CarouselSlider(
                      items: snapshot.data
                          .map((viewModel) => SurveyItem(viewModel: viewModel))
                          .toList(),
                      options: CarouselOptions(
                        enlargeCenterPage: true,
                        aspectRatio: 1.2,
                      )),
                );
              }
              return SizedBox(height: 0);
            });
      }),
    );
  }
}
