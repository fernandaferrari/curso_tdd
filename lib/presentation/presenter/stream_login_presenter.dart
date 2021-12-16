import 'dart:async';

import 'package:curso_tdd/domain/helpers/helpers.dart';
import 'package:curso_tdd/domain/usecases/usecases.dart';
import 'package:curso_tdd/presentation/presenter/dependencies/dependencies.dart';

class LoginState {
  String? email;
  String? password;
  String? emailError;
  String? passwordError;
  String? mainError;
  bool? isLoading = false;

  bool get isFormValid =>
      email != '' && password != '' && emailError == '' && passwordError == '';
}

class StreamLoginPresenter {
  final IAuthentication authentication;
  final IValidation? validation;
  final _controller = StreamController<LoginState>.broadcast();
  final _state = LoginState();

  StreamLoginPresenter(
      {required this.validation, required this.authentication});

  Stream<String?> get emailErrorStream =>
      _controller.stream.map((state) => state.emailError).distinct();
  Stream<String?> get passwordErrorStream =>
      _controller.stream.map((state) => state.passwordError).distinct();
  Stream<bool> get isFormValidStream =>
      _controller.stream.map((state) => state.isFormValid).distinct();
  Stream<bool?> get isLoadStream =>
      _controller.stream.map((state) => state.isLoading).distinct();
  Stream<String?> get mainErrorStream =>
      _controller.stream.map((state) => state.mainError).distinct();

  void _update() {
    if (!_controller.isClosed) {
      _controller.add(_state);
    }
  }

  void validateEmail(String email) {
    _state.email = email;
    _state.emailError = validation!.validate(field: 'email', value: email);
    _update();
  }

  void validatePassword(String password) {
    _state.password = password;
    _state.passwordError =
        validation!.validate(field: 'password', value: password);
    _update();
  }

  Future<void>? auth() async {
    _state.isLoading = true;
    _update();
    try {
      authentication.auth(
          AuthenticationParams(email: _state.email!, secret: _state.password!));
    } on DomainError catch (error) {
      _state.emailError = error.description;
      _update();
    }

    _state.isLoading = false;
    _update();
  }

  void dispose() {
    _controller.close();
  }
}
