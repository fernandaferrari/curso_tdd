import 'package:curso_tdd/main/factories/factories.dart';
import 'package:curso_tdd/ui/components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    final routeObserver = Get.put<RouteObserver>(RouteObserver<PageRoute>());

    return GetMaterialApp(
      title: 'TDD',
      debugShowCheckedModeBanner: false,
      theme: appTheme(),
      navigatorObservers: [routeObserver],
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: makeSplashPage, transition: Transition.fade),
        GetPage(
            name: '/login', page: makeLoginPage, transition: Transition.fadeIn),
        GetPage(name: '/signup', page: makeSignUpPage),
        GetPage(
            name: '/surveys',
            page: makeSurveysPage,
            transition: Transition.fadeIn),
        GetPage(name: '/survey_result/:survey_id', page: makeSurveyResultPage),
      ],
    );
  }
}
