import 'package:curso_tdd/data/usecases/usecase.dart';
import 'package:curso_tdd/infra/http/http_adapter.dart';
import 'package:curso_tdd/presentation/presenter/stream_login_presenter.dart';
import 'package:curso_tdd/ui/pages/login/login_page.dart';
import 'package:curso_tdd/validation/validators/email_validator.dart';
import 'package:curso_tdd/validation/validators/required_field_validation.dart';
import 'package:curso_tdd/validation/validators/validation_composite.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

Widget makeLoginPage() {
  const url = 'http://fordevs.herokuapp.com/apo/login';
  final client = Client();
  final httpAdapter = HttpAdapter(client);
  final remoteAuthentication =
      RemoteAuthentication(httpClient: httpAdapter, url: url);
  final validationComposite = ValidationComposite([
    RequiredFieldValidation('email'),
    EmailValidator('email'),
    RequiredFieldValidation('password')
  ]);

  final streamLoginPresenter = StreamLoginPresenter(
    authentication: remoteAuthentication,
    validation: validationComposite,
  );
  return LoginPage(streamLoginPresenter);
}
