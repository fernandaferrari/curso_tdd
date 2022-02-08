import 'package:curso_tdd/ui/components/components.dart';
import 'package:curso_tdd/ui/pages/pages.dart';
import 'package:flutter/material.dart';
import 'package:curso_tdd/ui/mixins/mixins.dart';

import 'package:curso_tdd/ui/helpers/helpers.dart';

import 'components/components.dart';

class SurveyResultPage extends StatelessWidget
    with LoadingManager, SessionManager {
  final SurveyResultPresenter presenter;

  const SurveyResultPage({Key? key, required this.presenter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(R.strings.surveys)),
      ),
      body: Builder(builder: (ctx) {
        handleLoading(context, presenter.isLoadStream);
        handleSessionExpired(presenter.isSessionExpiredStream);

        presenter.loadData();

        return StreamBuilder<SurveysResultViewModel?>(
            stream: presenter.surveysResultStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return ReloadScreen(
                  error: snapshot.error.toString(),
                  reload: presenter.loadData,
                );
              }

              if (snapshot.hasData) {
                return SurveyResult(
                  viewModel: snapshot.data!,
                  onSave: presenter.save,
                );
              }
              return SizedBox(height: 0);
            });
      }),
    );
  }
}
