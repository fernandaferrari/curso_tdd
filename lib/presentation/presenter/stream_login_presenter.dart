import 'dart:async';

import 'package:curso_tdd/domain/usecases/usecases.dart';
import 'package:curso_tdd/presentation/presenter/dependencies/dependencies.dart';

class LoginState {
  String? email;
  String? password;
  String? emailError;
  String? passwordError;

  bool get isFormValid =>
      email != '' && password != '' && emailError == '' && passwordError == '';
}

class StreamLoginPresenter {
  final IAuthentication authentication;
  final IValidation validation;
  final _controller = StreamController<LoginState>.broadcast();
  final _state = LoginState();

  StreamLoginPresenter(
      {required this.validation, required this.authentication});

  Stream<String> get emailErrorStream =>
      _controller.stream.map((state) => state.emailError ?? '').distinct();
  Stream<String> get passwordErrorStream =>
      _controller.stream.map((state) => state.passwordError ?? '').distinct();
  Stream<bool> get isFormValidStream =>
      _controller.stream.map((state) => state.isFormValid).distinct();

  void _update() => _controller.add(_state);

  void validateEmail(String email) {
    _state.email = email;
    _state.emailError = validation.validate(field: 'email', value: email);
    _update();
  }

  void validatePassword(String password) {
    _state.password = password;
    _state.passwordError =
        validation.validate(field: 'password', value: password);
    _update();
  }

  Future<void>? auth() async {
    authentication.auth(
        AuthenticationParams(email: _state.email!, secret: _state.password!));
  }
}
