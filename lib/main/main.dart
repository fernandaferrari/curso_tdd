import 'package:curso_tdd/main/factories/factories.dart';
import 'package:curso_tdd/main/factories/pages/splash/splash.dart';
import 'package:curso_tdd/ui/components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';

import 'factories/pages/signup/signup.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return GetMaterialApp(
      title: 'TDD',
      debugShowCheckedModeBanner: false,
      theme: appTheme(),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: makeSplashPage, transition: Transition.fade),
        GetPage(
            name: '/login', page: makeLoginPage, transition: Transition.fadeIn),
        GetPage(name: '/signup', page: makeSignUpPage),
        GetPage(
            name: '/surveys',
            page: () => Scaffold(body: Text('Enquetes')),
            transition: Transition.fadeIn)
      ],
    );
  }
}
