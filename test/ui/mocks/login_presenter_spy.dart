import 'dart:async';

import 'package:curso_tdd/ui/helpers/helpers.dart';
import 'package:curso_tdd/ui/pages/pages.dart';
import 'package:mocktail/mocktail.dart';

class LoginPresenterMock extends Mock implements ILoginPresenter {
  final emailErrorController = StreamController<UIError?>();
  final passwordErrorController = StreamController<UIError?>();
  final mainErrorController = StreamController<UIError?>();
  final navigateToController = StreamController<String?>();
  final isFormValidController = StreamController<bool>();
  final isLoadController = StreamController<bool>();

  LoginPresenterMock() {
    when(() => auth()).thenAnswer((_) async => _);
    when(() => emailErrorStream).thenAnswer((_) => emailErrorController.stream);
    when(() => isFormValidStream)
        .thenAnswer((_) => isFormValidController.stream);
    when(() => passwordErrorStream)
        .thenAnswer((_) => passwordErrorController.stream);
    when(() => navigateToStream).thenAnswer((_) => navigateToController.stream);
    when(() => isLoadStream).thenAnswer((_) => isLoadController.stream);
    when(() => mainErrorStream).thenAnswer((_) => mainErrorController.stream);
  }

  void emitEmailError(UIError error) => emailErrorController.add(error);
  void emitEmailValid() => emailErrorController.add(null);
  void emitPasswordError(UIError error) => passwordErrorController.add(error);
  void emitPasswordValid() => passwordErrorController.add(null);
  void emitFormError() => isFormValidController.add(false);
  void emitFormValid() => isFormValidController.add(true);
  void emitLoading([bool show = true]) => isLoadController.add(show);
  void emitMainError(UIError error) => mainErrorController.add(error);
  void emitNavigateTo(String route) => navigateToController.add(route);

  void dispose() {
    emailErrorController.close();
    isFormValidController.close();
    passwordErrorController.close();
    isLoadController.close();
    mainErrorController.close();
    navigateToController.close();
  }
}
