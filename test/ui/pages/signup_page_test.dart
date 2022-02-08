import 'package:curso_tdd/ui/helpers/helpers.dart';
import 'package:curso_tdd/ui/pages/pages.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/helpers.dart';
import '../mocks/signup_presenter_spy.dart';

void main() {
  late SignUpPresenterSpy presenter;

  Future<void> loadPage(WidgetTester tester) async {
    presenter = SignUpPresenterSpy();

    await tester.pumpWidget(makePage(
        path: '/signup', page: () => SignUpPage(presenter: presenter)));
  }

  testWidgets('Validação do formulario quando os valores estão corretos ...',
      (tester) async {
    await loadPage(tester);

    final name = faker.person.name();
    await tester.enterText(find.bySemanticsLabel('Nome'), name);
    verify(() => presenter.validateName(name));

    final email = faker.internet.email();
    await tester.enterText(find.bySemanticsLabel('E-mail'), email);
    verify(() => presenter.validateEmail(email));

    final password = faker.internet.password();
    await tester.enterText(find.bySemanticsLabel('Senha'), password);
    verify(() => presenter.validatePassword(password));

    final passwordConfirm = faker.internet.password();
    await tester.enterText(
        find.bySemanticsLabel('Confirmar senha.'), passwordConfirm);
    verify(() => presenter.validateConfirmPassword(passwordConfirm));
  });

  testWidgets('simulação de erro para email...', (tester) async {
    await loadPage(tester);

    presenter.emitEmailError(UIError.requiredField);
    await tester.pump();
    expect(find.text('Campo obrigatório.'), findsOneWidget);

    presenter.emitEmailError(UIError.invalidField);
    await tester.pump();
    expect(find.text('Campo inválido.'), findsOneWidget);

    presenter.emitEmailValid();
    await tester.pump();

    expect(
        find.descendant(
            of: find.bySemanticsLabel("E-mail"), matching: find.byType(Text)),
        findsOneWidget);
  });

  testWidgets('simulação de erro para nome...', (tester) async {
    await loadPage(tester);

    presenter.emitNameError(UIError.requiredField);
    await tester.pump();
    expect(find.text('Campo obrigatório.'), findsOneWidget);

    presenter.emitNameError(UIError.invalidField);
    await tester.pump();
    expect(find.text('Campo inválido.'), findsOneWidget);

    presenter.emitNameValid();
    await tester.pump();

    expect(
        find.descendant(
            of: find.bySemanticsLabel("Nome"), matching: find.byType(Text)),
        findsOneWidget);
  });

  testWidgets('simulação de erro para password...', (tester) async {
    await loadPage(tester);

    presenter.emitPasswordError(UIError.requiredField);
    await tester.pump();
    expect(find.text('Campo obrigatório.'), findsOneWidget);

    presenter.emitPasswordError(UIError.invalidField);
    await tester.pump();
    expect(find.text('Campo inválido.'), findsOneWidget);

    presenter.emitPasswordValid();
    await tester.pump();

    expect(
        find.descendant(
            of: find.bySemanticsLabel("Senha"), matching: find.byType(Text)),
        findsOneWidget);
  });

  testWidgets('simulação de erro para confirmar senha...', (tester) async {
    await loadPage(tester);

    presenter.emitPasswordConfirmationError(UIError.requiredField);
    await tester.pump();
    expect(find.text('Campo obrigatório.'), findsOneWidget);

    presenter.emitPasswordConfirmationError(UIError.invalidField);
    await tester.pump();
    expect(find.text('Campo inválido.'), findsOneWidget);

    presenter.emitPasswordConfirmationValid();
    await tester.pump();

    expect(
        find.descendant(
            of: find.bySemanticsLabel("Confirmar senha."),
            matching: find.byType(Text)),
        findsOneWidget);
  });

  testWidgets('Habilitado botão quando o form é valido...', (tester) async {
    await loadPage(tester);

    presenter.emitFormValid();
    await tester.pump();

    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(button.onPressed, isNotNull);
  });

  testWidgets('Desabilitado botão quando o valor do form é false...',
      (tester) async {
    await loadPage(tester);

    presenter.emitFormError();
    await tester.pump();

    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(button.onPressed, isNull);
  });

  testWidgets(
      'Direcionado para a function signup quando o form for submetido...',
      (tester) async {
    await loadPage(tester);

    presenter.emitFormValid();
    await tester.pump();
    final button = find.byType(ElevatedButton);
    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pump();

    verify(() => presenter.signup()).called(1);
  });

  testWidgets('Load presente na tela...', (tester) async {
    await loadPage(tester);

    presenter.emitLoading();
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Load não esta presente na tela...', (tester) async {
    await loadPage(tester);

    presenter.emitLoading();
    await tester.pump();
    presenter.emitLoading(false);
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('Mensagem de erro quando a function signup falhar...',
      (tester) async {
    await loadPage(tester);

    presenter.emitMainError(UIError.emailInUse);
    await tester.pump();

    expect(find.text('E-mail já está em uso'), findsOneWidget);
  });

  testWidgets(
      'Mensagem de erro quando a function signup ter um erro inexperado...',
      (tester) async {
    await loadPage(tester);

    presenter.emitMainError(UIError.unexpected);
    await tester.pump();

    expect(find.text('Algo errado aconteceu. Tente novamente em breve.'),
        findsOneWidget);
  });

  testWidgets('Should change page...', (tester) async {
    await loadPage(tester);
    presenter.emitNavigateTo('/any_route');
    await tester.pumpAndSettle();

    expect(currentRoute, '/any_route');
    expect(find.text('fake page'), findsOneWidget);
  });

  testWidgets('Should not change page...', (tester) async {
    await loadPage(tester);

    presenter.emitNavigateTo('');
    await tester.pump();
    expect(currentRoute, '/signup');
  });

  testWidgets('should call goToSingUp on link click..', (tester) async {
    await loadPage(tester);

    final button = find.text('Login');

    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pump();

    verify(() => presenter.goToLogin()).called(1);
  });
}
