import 'dart:async';

import 'package:curso_tdd/presentation/presenter/dependencies/dependencies.dart';

class LoginState {
  String? emailError;
  String? passwordError;

  bool get isFormValid => false;
}

class StreamLoginPresenter {
  final IValidation validation;
  final _controller = StreamController<LoginState>.broadcast();

  final _state = LoginState();

  Stream<String> get emailErrorStream =>
      _controller.stream.map((state) => state.emailError!).distinct();
  Stream<String> get passwordErrorStream =>
      _controller.stream.map((state) => state.emailError!).distinct();
  Stream<bool> get isFormValidStream =>
      _controller.stream.map((state) => state.isFormValid).distinct();

  void _update() => _controller.add(_state);

  StreamLoginPresenter({required this.validation});
  void validateEmail(String email) {
    _state.emailError = validation.validate(field: 'email', value: email);
    _update();
  }

  void validatePassword(String password) {
    _state.passwordError =
        validation.validate(field: 'password', value: password);
    _update();
  }
}
