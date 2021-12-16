import 'dart:async';

import 'package:curso_tdd/ui/pages/pages.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class LoginPresenterMock extends Mock implements ILoginPresenter {}

void main() {
  ILoginPresenter? presenter;
  StreamController<String>? emailErrorController;
  StreamController<String>? passwordErrorController;
  StreamController<String>? mainErrorController;
  StreamController<bool>? isFormValidController;
  StreamController<bool>? isLoadController;

  void initStreams() {
    emailErrorController = StreamController<String>();
    passwordErrorController = StreamController<String>();
    mainErrorController = StreamController<String>();
    isFormValidController = StreamController<bool>();
    isLoadController = StreamController<bool>();
  }

  void mockStreams() {
    when(() => presenter!.emailErrorStream)
        .thenAnswer((_) => emailErrorController!.stream);
    when(() => presenter!.isFormValidStream)
        .thenAnswer((_) => isFormValidController!.stream);
    when(() => presenter!.passwordErrorStream)
        .thenAnswer((_) => passwordErrorController!.stream);
    when(() => presenter!.isLoadStream)
        .thenAnswer((_) => isLoadController!.stream);
    when(() => presenter!.mainErrorStream)
        .thenAnswer((_) => mainErrorController!.stream);
  }

  void closeStreams() {
    emailErrorController!.close();
    isFormValidController!.close();
    passwordErrorController!.close();
    isLoadController!.close();
    mainErrorController!.close();
  }

  Future<void> loadPage(WidgetTester tester) async {
    presenter = LoginPresenterMock();

    initStreams();
    mockStreams();

    final loginPage = MaterialApp(
        home: LoginPage(
      presenter!,
    ));
    await tester.pumpWidget(loginPage);
  }

  tearDown(() {
    closeStreams();
  });

  testWidgets('Estado inicial da tela de login ...', (tester) async {
    await loadPage(tester);

    final emailTextChildren = find.descendant(
        of: find.bySemanticsLabel('E-mail'), matching: find.byType(Text));
    expect(emailTextChildren, findsOneWidget);

    final passwordTextChildren = find.descendant(
        of: find.bySemanticsLabel('Password'), matching: find.byType(Text));
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

    verify(() => presenter!.validateEmail(email));

    final password = faker.internet.password();
    await tester.enterText(find.bySemanticsLabel('Password'), password);

    verify(() => presenter!.validatePassword(password));
  });

  testWidgets('simulação de erro quando email é invalido ...', (tester) async {
    await loadPage(tester);

    when(() => presenter!.emailErrorStream)
        .thenAnswer((_) => emailErrorController!.stream);
    emailErrorController!.add('any error');
    await tester.pump();

    expect(find.text('any error'), findsOneWidget);
  });

  testWidgets('simulação de erro quando password é invalido ...',
      (tester) async {
    await loadPage(tester);

    when(() => presenter!.passwordErrorStream)
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

    verify(() => presenter!.auth()).called(1);
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

  testWidgets('Mensagem de erro quando a autenticação falhar...',
      (tester) async {
    await loadPage(tester);

    mainErrorController!.add('main error');
    await tester.pump();

    expect(find.text('main error'), findsOneWidget);
  });

  testWidgets('Dispose nas streams quando forem fechadas...', (tester) async {
    await loadPage(tester);

    addTearDown(() {
      verify(() => presenter!.dispose()).called(1);
    });
  });
}
