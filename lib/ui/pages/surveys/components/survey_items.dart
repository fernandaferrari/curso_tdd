import 'package:carousel_slider/carousel_slider.dart';
import 'package:curso_tdd/ui/pages/pages.dart';
import 'package:curso_tdd/ui/pages/surveys/components/components.dart';
import 'package:flutter/material.dart';

class SurveyItems extends StatelessWidget {
  final List<SurveysViewModel> data;
  SurveyItems({
    Key key,
    @required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: CarouselSlider(
          items: data
              .map((viewModel) => SurveyItem(viewModel: viewModel))
              .toList(),
          options: CarouselOptions(
            enlargeCenterPage: true,
            aspectRatio: 1.2,
          )),
    );
  }
}
