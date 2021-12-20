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
    return GetMaterialApp(
      title: 'TDD',
      debugShowCheckedModeBanner: false,
      theme: appTheme(),
      initialRoute: '/login',
      getPages: [GetPage(name: '/login', page: makeLoginPage)],
    );
  }
}
