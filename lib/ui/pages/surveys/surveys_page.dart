import 'package:curso_tdd/ui/mixins/mixins.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:curso_tdd/ui/components/components.dart';
import 'package:curso_tdd/ui/helpers/helpers.dart';
import 'package:curso_tdd/ui/pages/surveys/components/components.dart';
import 'package:curso_tdd/ui/pages/surveys/surveys_presenter.dart';
import 'package:curso_tdd/ui/pages/surveys/surveys_view_model.dart';
import 'package:provider/provider.dart';

class SurveysPage extends StatefulWidget {
  final SurveysPresenter presenter;
  const SurveysPage(
    this.presenter,
  );

  @override
  _SurveysPageState createState() => _SurveysPageState();
}

class _SurveysPageState extends State<SurveysPage>
    with LoadingManager, NavigateManager, SessionManager, RouteAware {
  @override
  Widget build(BuildContext context) {
    Get.find<RouteObserver>()
        .subscribe(this, ModalRoute.of(context) as PageRoute);
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(R.strings.surveys)),
      ),
      body: Builder(builder: (context) {
        handleLoading(context, widget.presenter.isLoadStream);
        handleSessionExpired(widget.presenter.isSessionExpiredStream);
        handleNavigate(widget.presenter.navigateToStream);
        widget.presenter.loadData();

        return StreamBuilder<List<SurveysViewModel>>(
            stream: widget.presenter.surveysStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return ReloadScreen(
                  error: snapshot.error.toString(),
                  reload: widget.presenter.loadData,
                );
              }

              if (snapshot.hasData) {
                return ListenableProvider(
                    create: (_) => widget.presenter,
                    child: SurveyItems(data: snapshot.data!));
              }
              return SizedBox(height: 0);
            });
      }),
    );
  }

  @override
  void didPopNext() {
    widget.presenter.loadData();
  }

  @override
  void dispose() {
    Get.find<RouteObserver>().unsubscribe(this);
    super.dispose();
  }
}
