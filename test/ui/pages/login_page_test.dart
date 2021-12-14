import 'dart:async';

import 'package:curso_tdd/ui/pages/pages.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class LoginPresenterMock extends Mock implements ILoginPresenter {}

void main() {
  ILoginPresenter? presenter;
  StreamController<String>? emailErrorController;
  StreamController<String>? passwordErrorController;
  StreamController<String>? mainErrorController;
  StreamController<bool>? isFormValidController;
  StreamController<bool>? isLoadController;

  Future<void> loadPage(WidgetTester tester) async {
    presenter = LoginPresenterMock();
    emailErrorController = StreamController<String>();
    passwordErrorController = StreamController<String>();
    mainErrorController = StreamController<String>();
    isFormValidController = StreamController<bool>();
    isLoadController = StreamController<bool>();

    when(presenter!.emailErrorStream)
        .thenAnswer((_) => emailErrorController!.stream);
    when(presenter!.isFormValidStream)
        .thenAnswer((_) => isFormValidController!.stream);
    when(presenter!.passwordErrorStream)
        .thenAnswer((_) => passwordErrorController!.stream);
    when(presenter!.isLoadStream).thenAnswer((_) => isLoadController!.stream);
    when(presenter!.mainErrorStream)
        .thenAnswer((_) => mainErrorController!.stream);
    final loginPage = MaterialApp(
        home: LoginPage(
      presenter,
    ));
    await tester.pumpWidget(loginPage);
  }

  tearDown(() {
    emailErrorController!.close();
    isFormValidController!.close();
    passwordErrorController!.close();
    isLoadController!.close();
    mainErrorController!.close();
  });

  testWidgets('Estado inicial da tela de login ...', (tester) async {
    await loadPage(tester);

    final emailTextChildren = find.descendant(
        of: find.bySemanticsLabel('E-mail'), matching: find.byType(Text));
    expect(emailTextChildren, findsOneWidget);

    final passwordTextChildren = find.descendant(
        of: find.bySemanticsLabel('Senha'), matching: find.byType(Text));
    expect(passwordTextChildren, findsOneWidget);

    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(button.onPressed, null);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('Validação do formulario quando os valores estão corretos ...',
      (tester) async {
    await loadPage(tester);

    final email = faker.internet.email();
    await tester.enterText(find.bySemanticsLabel('E-mail'), email);

    verify(presenter!.validateEmail(email));

    final password = faker.internet.password();
    await tester.enterText(find.bySemanticsLabel('Senha'), password);

    verify(presenter!.validatePassword(password));
  });

  testWidgets('simulação de erro quando email é invalido ...', (tester) async {
    await loadPage(tester);

    when(presenter!.emailErrorStream)
        .thenAnswer((_) => emailErrorController!.stream);
    emailErrorController!.add('any error');
    await tester.pump();

    expect(find.text('any error'), findsOneWidget);
  });

  testWidgets('simulação de erro quando password é invalido ...',
      (tester) async {
    await loadPage(tester);

    when(presenter!.passwordErrorStream)
        .thenAnswer((_) => passwordErrorController!.stream);

    passwordErrorController!.add('any error');
    await tester.pump();

    expect(find.text('any error'), findsOneWidget);
  });

  testWidgets('Habilitado botão quando o form é valido...', (tester) async {
    await loadPage(tester);

    isFormValidController!.add(true);
    await tester.pump();

    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(button.onPressed, isNotNull);
  });

  testWidgets('Desabilitado botão quando o valor do form é false...',
      (tester) async {
    await loadPage(tester);

    isFormValidController!.add(false);
    await tester.pump();

    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(button.onPressed, isNull);
  });

  testWidgets('Direcionado a autenticação quando o form for submetido...',
      (tester) async {
    await loadPage(tester);

    isFormValidController!.add(true);
    await tester.pump();
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    verify(presenter!.auth()).called(1);
  });

  testWidgets('Load presente na tela...', (tester) async {
    await loadPage(tester);

    isLoadController!.add(true);
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Load não esta presente na tela...', (tester) async {
    await loadPage(tester);

    isLoadController!.add(true);
    await tester.pump();
    isLoadController!.add(false);
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('Load não esta presente na tela...', (tester) async {
    await loadPage(tester);

    isLoadController!.add(true);
    await tester.pump();
    isLoadController!.add(false);
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('Mensagem de erro quando a autenticação falhar...',
      (tester) async {
    await loadPage(tester);

    mainErrorController!.add('main error');
    await tester.pump();

    expect(find.text('main error'), findsOneWidget);
  });
}
