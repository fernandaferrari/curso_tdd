import 'package:flutter/material.dart';

import 'package:curso_tdd/ui/helpers/helpers.dart';

class SurveyResultPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text(R.strings.surveys)),
        ),
        body: Text('Result'));
  }
}
