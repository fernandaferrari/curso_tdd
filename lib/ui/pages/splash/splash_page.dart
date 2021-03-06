import 'package:curso_tdd/ui/pages/splash/splash.dart';
import 'package:flutter/material.dart';
import 'package:curso_tdd/ui/mixins/mixins.dart';

class SplashPage extends StatelessWidget with NavigateManager {
  final SplashPresenter presenter;

  SplashPage({
    required this.presenter,
  });

  @override
  Widget build(BuildContext context) {
    presenter.checkAccount();
    return Scaffold(
      appBar: AppBar(
        title: Text('4Dev'),
      ),
      body: Builder(builder: (_) {
        handleNavigate(presenter.navigateToStream, clear: true);

        return Center(
          child: CircularProgressIndicator(),
        );
      }),
    );
  }
}
