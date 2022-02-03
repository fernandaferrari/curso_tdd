import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:curso_tdd/ui/mixins/mixins.dart';

import 'package:curso_tdd/ui/components/components.dart';
import 'package:curso_tdd/ui/helpers/helpers.dart';
import 'package:curso_tdd/ui/pages/surveys/components/components.dart';
import 'package:curso_tdd/ui/pages/surveys/surveys_presenter.dart';
import 'package:curso_tdd/ui/pages/surveys/surveys_view_model.dart';
import 'package:provider/provider.dart';

class SurveysPage extends StatelessWidget
    with LoadingManager, NavigateManager, SessionManager {
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
        handleLoading(context, presenter.isLoadStream);

        handleSessionExpired(context, presenter.isSessionExpiredStream);

        handleNavigate(context, presenter.navigateToStream);

        presenter.loadData();
        return StreamBuilder<List<SurveysViewModel>>(
            stream: presenter.surveysStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return ReloadScreen(
                  error: snapshot.error,
                  reload: presenter.loadData,
                );
              }

              if (snapshot.hasData) {
                return Provider(
                    create: (_) => presenter,
                    child: SurveyItems(data: snapshot.data));
              }
              return SizedBox(height: 0);
            });
      }),
    );
  }
}
