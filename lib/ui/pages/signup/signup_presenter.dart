import 'package:curso_tdd/ui/helpers/errors/errors.dart';

abstract class SignUpPresenter {
  Stream<UIError> get nameErrorStream;
  Stream<UIError> get emailErrorStream;
  Stream<UIError> get passwordErrorStream;
  Stream<UIError> get confirmPasswordErrorStream;
  Stream<bool> get isFormValidStream;
  Stream<bool> get isLoadStream;

  void validateName(String name);
  void validateEmail(String email);
  void validatePassword(String password);
  void validateConfirmPassword(String password);
  Future<void> signup();
}
