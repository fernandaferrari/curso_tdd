import 'package:curso_tdd/main/factories/pages/splash/splash.dart';
import 'package:flutter/material.dart';

import '../../../../ui/pages/pages.dart';

Widget makeSplashPage() {
  return SplashPage(presenter: makeGetxSplashPresenter());
}
