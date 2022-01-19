import 'dart:async';

import 'package:curso_tdd/ui/helpers/helpers.dart';
import 'package:curso_tdd/ui/pages/pages.dart';
import 'package:curso_tdd/ui/pages/signup/signup_presenter.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';

class SignUpPresenterSpy extends Mock implements SignUpPresenter {}

void main() {
  SignUpPresenterSpy presenter;
  StreamController<UIError> emailErrorController;
  StreamController<UIError> passwordErrorController;
  StreamController<UIError> nameErrorController;
  StreamController<UIError> passwordConfirmErrorController;
  StreamController<UIError> mainErrorController;
  StreamController<bool> isFormValidController;
  StreamController<bool> isLoadController;
  StreamController<String> navigateToController;

  void initStreams() {
    emailErrorController = StreamController<UIError>();
    passwordErrorController = StreamController<UIError>();
    nameErrorController = StreamController<UIError>();
    passwordConfirmErrorController = StreamController<UIError>();
    isFormValidController = StreamController<bool>();
    isLoadController = StreamController<bool>();
    mainErrorController = StreamController<UIError>();
    navigateToController = StreamController<String>();
  }

  void mockStreams() {
    when(presenter.nameErrorStream)
        .thenAnswer((_) => nameErrorController.stream);
    when(presenter.emailErrorStream)
        .thenAnswer((_) => emailErrorController.stream);
    when(presenter.passwordErrorStream)
        .thenAnswer((_) => passwordErrorController.stream);
    when(presenter.confirmPasswordErrorStream)
        .thenAnswer((_) => passwordConfirmErrorController.stream);
    when(presenter.isFormValidStream)
        .thenAnswer((_) => isFormValidController.stream);
    when(presenter.isLoadStream).thenAnswer((_) => isLoadController.stream);
    when(presenter.mainErrorStream)
        .thenAnswer((_) => mainErrorController.stream);
    when(presenter.navigateToStream)
        .thenAnswer((_) => navigateToController.stream);
  }

  void closeStreams() {
    nameErrorController.close();
    emailErrorController.close();
    passwordErrorController.close();
    passwordConfirmErrorController.close();
    isFormValidController.close();
    isLoadController.close();
    mainErrorController.close();
    navigateToController.close();
  }

  Future<void> loadPage(WidgetTester tester) async {
    presenter = SignUpPresenterSpy();
    initStreams();
    mockStreams();
    final signUpPage = GetMaterialApp(initialRoute: '/signup', getPages: [
      GetPage(name: '/signup', page: () => SignUpPage(presenter: presenter)),
      GetPage(
          name: '/any_route',
          page: () => Scaffold(
                body: Text('fake page'),
              )),
    ]);
    await tester.pumpWidget(signUpPage);
  }

  tearDown(() {
    closeStreams();
  });

  testWidgets('Validação do formulario quando os valores estão corretos ...',
      (tester) async {
    await loadPage(tester);

    final name = faker.person.name();
    await tester.enterText(find.bySemanticsLabel('Nome'), name);
    verify(presenter.validateName(name));

    final email = faker.internet.email();
    await tester.enterText(find.bySemanticsLabel('E-mail'), email);
    verify(presenter.validateEmail(email));

    final password = faker.internet.password();
    await tester.enterText(find.bySemanticsLabel('Senha'), password);
    verify(presenter.validatePassword(password));

    final passwordConfirm = faker.internet.password();
    await tester.enterText(
        find.bySemanticsLabel('Confirmar senha.'), passwordConfirm);
    verify(presenter.validateConfirmPassword(passwordConfirm));
  });

  testWidgets('simulação de erro para email...', (tester) async {
    await loadPage(tester);

    when(presenter.emailErrorStream)
        .thenAnswer((_) => emailErrorController.stream);
    emailErrorController.add(UIError.requiredField);
    await tester.pump();

    expect(find.text('Campo obrigatório.'), findsOneWidget);

    emailErrorController.add(UIError.invalidField);
    await tester.pump();

    expect(find.text('Campo inválido.'), findsOneWidget);

    emailErrorController.add(null);
    await tester.pump();

    expect(
        find.descendant(
            of: find.bySemanticsLabel("E-mail"), matching: find.byType(Text)),
        findsOneWidget);
  });

  testWidgets('simulação de erro para nome...', (tester) async {
    await loadPage(tester);

    when(presenter.nameErrorStream)
        .thenAnswer((_) => nameErrorController.stream);
    nameErrorController.add(UIError.requiredField);
    await tester.pump();

    expect(find.text('Campo obrigatório.'), findsOneWidget);

    nameErrorController.add(UIError.invalidField);
    await tester.pump();

    expect(find.text('Campo inválido.'), findsOneWidget);

    nameErrorController.add(null);
    await tester.pump();

    expect(
        find.descendant(
            of: find.bySemanticsLabel("Nome"), matching: find.byType(Text)),
        findsOneWidget);
  });

  testWidgets('simulação de erro para password...', (tester) async {
    await loadPage(tester);

    when(presenter.passwordErrorStream)
        .thenAnswer((_) => passwordErrorController.stream);
    passwordErrorController.add(UIError.requiredField);
    await tester.pump();

    expect(find.text('Campo obrigatório.'), findsOneWidget);

    passwordErrorController.add(UIError.invalidField);
    await tester.pump();

    expect(find.text('Campo inválido.'), findsOneWidget);

    passwordErrorController.add(null);
    await tester.pump();

    expect(
        find.descendant(
            of: find.bySemanticsLabel("Senha"), matching: find.byType(Text)),
        findsOneWidget);
  });

  testWidgets('simulação de erro para confirmar senha...', (tester) async {
    await loadPage(tester);

    when(presenter.confirmPasswordErrorStream)
        .thenAnswer((_) => passwordConfirmErrorController.stream);
    passwordConfirmErrorController.add(UIError.requiredField);
    await tester.pump();

    expect(find.text('Campo obrigatório.'), findsOneWidget);

    passwordConfirmErrorController.add(UIError.invalidField);
    await tester.pump();

    expect(find.text('Campo inválido.'), findsOneWidget);

    passwordConfirmErrorController.add(null);
    await tester.pump();

    expect(
        find.descendant(
            of: find.bySemanticsLabel("Confirmar senha."),
            matching: find.byType(Text)),
        findsOneWidget);
  });

  testWidgets('Habilitado botão quando o form é valido...', (tester) async {
    await loadPage(tester);

    isFormValidController.add(true);
    await tester.pump();

    final button = tester.widget<RaisedButton>(find.byType(RaisedButton));
    expect(button.onPressed, isNotNull);
  });

  testWidgets('Desabilitado botão quando o valor do form é false...',
      (tester) async {
    await loadPage(tester);

    isFormValidController.add(false);
    await tester.pump();

    final button = tester.widget<RaisedButton>(find.byType(RaisedButton));
    expect(button.onPressed, isNull);
  });

  testWidgets(
      'Direcionado para a function signup quando o form for submetido...',
      (tester) async {
    await loadPage(tester);

    isFormValidController.add(true);
    await tester.pump();
    final button = find.byType(RaisedButton);
    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pump();

    verify(presenter.signup()).called(1);
  });

  testWidgets('Load presente na tela...', (tester) async {
    await loadPage(tester);

    isLoadController.add(true);
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Load não esta presente na tela...', (tester) async {
    await loadPage(tester);

    isLoadController.add(true);
    await tester.pump();
    isLoadController.add(false);
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('Mensagem de erro quando a function signup falhar...',
      (tester) async {
    await loadPage(tester);

    mainErrorController.add(UIError.invalidCredentials);
    await tester.pump();

    expect(find.text('Credenciais inválidas.'), findsOneWidget);
  });

  testWidgets(
      'Mensagem de erro quando a function signup ter um erro inexperado...',
      (tester) async {
    await loadPage(tester);

    mainErrorController.add(UIError.unexpected);
    await tester.pump();

    expect(find.text('Algo errado aconteceu. Tente novamente em breve.'),
        findsOneWidget);
  });

  testWidgets('Should change page...', (tester) async {
    await loadPage(tester);

    navigateToController.add('/any_route');
    await tester.pumpAndSettle();

    expect(Get.currentRoute, '/any_route');
    expect(find.text('fake page'), findsOneWidget);
  });

  testWidgets('Should not change page...', (tester) async {
    await loadPage(tester);

    navigateToController.add('');
    await tester.pump();
    expect(Get.currentRoute, '/signup');

    navigateToController.add(null);
    await tester.pump();
    expect(Get.currentRoute, '/signup');
  });

  testWidgets('should call goToSingUp on link click..', (tester) async {
    await loadPage(tester);

    final button = find.text('Login');

    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pump();

    verify(presenter.goToLogin()).called(1);
  });
}
