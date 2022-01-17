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
  StreamController<bool> isFormValidController;
  StreamController<bool> isLoadController;

  void initStreams() {
    emailErrorController = StreamController<UIError>();
    passwordErrorController = StreamController<UIError>();
    nameErrorController = StreamController<UIError>();
    passwordConfirmErrorController = StreamController<UIError>();
    isFormValidController = StreamController<bool>();
    isLoadController = StreamController<bool>();
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
  }

  void closeStreams() {
    nameErrorController.close();
    emailErrorController.close();
    passwordErrorController.close();
    passwordConfirmErrorController.close();
    isFormValidController.close();
  }

  Future<void> loadPage(WidgetTester tester) async {
    presenter = SignUpPresenterSpy();
    initStreams();
    mockStreams();
    final signUpPage = GetMaterialApp(initialRoute: '/signup', getPages: [
      GetPage(name: '/signup', page: () => SignUpPage(presenter: presenter)),
    ]);
    await tester.pumpWidget(signUpPage);
  }

  tearDown(() {
    closeStreams();
  });

  testWidgets('Estado inicial da tela de sigup ...', (tester) async {
    await loadPage(tester);

    final nameTextChildren = find.descendant(
        of: find.bySemanticsLabel('Nome'), matching: find.byType(Text));
    expect(nameTextChildren, findsOneWidget);

    final emailTextChildren = find.descendant(
        of: find.bySemanticsLabel('E-mail'), matching: find.byType(Text));
    expect(emailTextChildren, findsOneWidget);

    final passwordTextChildren = find.descendant(
        of: find.bySemanticsLabel('Senha'), matching: find.byType(Text));
    expect(passwordTextChildren, findsOneWidget);

    final passwordConfirmationTextChildren = find.descendant(
        of: find.bySemanticsLabel('Confirmar senha.'),
        matching: find.byType(Text));
    expect(passwordConfirmationTextChildren, findsOneWidget);

    final button = tester.widget<RaisedButton>(find.byType(RaisedButton));
    expect(button.onPressed, null);
    expect(find.byType(CircularProgressIndicator), findsNothing);
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
}
