import 'dart:async';

import 'package:curso_tdd/ui/helpers/helpers.dart';
import 'package:curso_tdd/ui/pages/pages.dart';
import 'package:mocktail/mocktail.dart';

class SignUpPresenterSpy extends Mock implements SignUpPresenter {
  final emailErrorController = StreamController<UIError?>();
  final passwordErrorController = StreamController<UIError?>();
  final nameErrorController = StreamController<UIError?>();
  final passwordConfirmErrorController = StreamController<UIError?>();
  final isFormValidController = StreamController<bool>();
  final isLoadController = StreamController<bool>();
  final mainErrorController = StreamController<UIError?>();
  final navigateToController = StreamController<String?>();

  SignUpPresenterSpy() {
    when(() => signup()).thenAnswer((_) async => _);
    when(() => goToLogin()).thenAnswer((_) async => _);
    when(() => nameErrorStream).thenAnswer((_) => nameErrorController.stream);
    when(() => emailErrorStream).thenAnswer((_) => emailErrorController.stream);
    when(() => passwordErrorStream)
        .thenAnswer((_) => passwordErrorController.stream);
    when(() => confirmPasswordErrorStream)
        .thenAnswer((_) => passwordConfirmErrorController.stream);
    when(() => isFormValidStream)
        .thenAnswer((_) => isFormValidController.stream);
    when(() => isLoadStream).thenAnswer((_) => isLoadController.stream);
    when(() => mainErrorStream).thenAnswer((_) => mainErrorController.stream);
    when(() => navigateToStream).thenAnswer((_) => navigateToController.stream);
  }

  void emitNameError(UIError error) => nameErrorController.add(error);
  void emitNameValid() => nameErrorController.add(null);
  void emitEmailError(UIError error) => emailErrorController.add(error);
  void emitEmailValid() => emailErrorController.add(null);
  void emitPasswordError(UIError error) => passwordErrorController.add(error);
  void emitPasswordValid() => passwordErrorController.add(null);
  void emitPasswordConfirmationError(UIError error) =>
      passwordConfirmErrorController.add(error);
  void emitPasswordConfirmationValid() =>
      passwordConfirmErrorController.add(null);
  void emitFormError() => isFormValidController.add(false);
  void emitFormValid() => isFormValidController.add(true);
  void emitLoading([bool show = true]) => isLoadController.add(show);
  void emitMainError(UIError error) => mainErrorController.add(error);
  void emitNavigateTo(String route) => navigateToController.add(route);

  void dispose() {
    nameErrorController.close();
    emailErrorController.close();
    passwordErrorController.close();
    passwordConfirmErrorController.close();
    isFormValidController.close();
    isLoadController.close();
    mainErrorController.close();
    navigateToController.close();
  }
}
