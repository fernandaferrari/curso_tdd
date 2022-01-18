import 'package:curso_tdd/main/factories/pages/signup/signup.dart';
import 'package:flutter/material.dart';

import '../../../../ui/pages/pages.dart';

Widget makeSignUpPage() {
  return SignUpPage(presenter: makeGetxSignUpPresenter());
}
