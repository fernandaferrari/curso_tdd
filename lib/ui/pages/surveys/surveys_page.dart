import 'package:carousel_slider/carousel_slider.dart';
import 'package:curso_tdd/ui/helpers/helpers.dart';
import 'package:curso_tdd/ui/pages/surveys/components/components.dart';
import 'package:flutter/material.dart';

class SurveysPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(R.strings.surveys)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: CarouselSlider(items: [
          SurveyItem()
        ], options: CarouselOptions(enlargeCenterPage: true, aspectRatio: 1.2)),
      ),
    );
  }
}
