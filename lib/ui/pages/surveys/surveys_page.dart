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
    presenter.loadData();

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
        return StreamBuilder<List<SurveysViewModel>>(
            stream: presenter.loadSurveysStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Column(
                  children: [
                    Text(snapshot.error),
                    RaisedButton(
                      onPressed: presenter.loadData,
                      child: Text(R.strings.reload),
                    )
                  ],
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
