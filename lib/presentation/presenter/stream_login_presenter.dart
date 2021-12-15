import 'dart:async';

import 'package:curso_tdd/presentation/presenter/dependencies/dependencies.dart';

class LoginState {
  String? emailError;
}

class StreamLoginPresenter {
  final IValidation validation;
  final _controller = StreamController<LoginState>.broadcast();

  final _state = LoginState();

  Stream<String> get emailErrorStream =>
      _controller.stream.map((state) => state.emailError!).distinct();

  StreamLoginPresenter({required this.validation});
  void validateEmail(String email) {
    _state.emailError = validation.validate(field: 'email', value: email);
    _controller.add(_state);
  }
}
