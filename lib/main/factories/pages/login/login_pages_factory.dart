import 'package:curso_tdd/main/factories/factories.dart';
import 'package:curso_tdd/ui/pages/login/login_page.dart';
import 'package:flutter/material.dart';

Widget makeLoginPage() {
  return LoginPage(makeLoginPresenter());
}
