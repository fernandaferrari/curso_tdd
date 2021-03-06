import 'package:curso_tdd/ui/helpers/errors/errors.dart';
import 'package:flutter/material.dart';

abstract class ILoginPresenter implements Listenable {
  Stream<UIError?> get emailErrorStream;
  Stream<UIError?> get passwordErrorStream;
  Stream<UIError?> get mainErrorStream;
  Stream<String?> get navigateToStream;
  Stream<bool> get isFormValidStream;
  Stream<bool> get isLoadStream;

  void validateEmail(String email);
  void validatePassword(String password);
  Future<void> auth();
  void goToSingUp();
}
