import 'package:curso_tdd/ui/helpers/errors/ui_error.dart';
import 'package:curso_tdd/ui/pages/pages.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/helpers.dart';
import '../mocks/mocks.dart';

void main() {
  late LoginPresenterMock presenter;
  Future<void> loadPage(WidgetTester tester) async {
    presenter = LoginPresenterMock();

    await tester
        .pumpWidget(makePage(path: '/login', page: () => LoginPage(presenter)));
  }

  testWidgets('Validação do formulario quando os valores estão corretos ...',
      (tester) async {
    await loadPage(tester);

    final email = faker.internet.email();
    await tester.enterText(find.bySemanticsLabel('E-mail'), email);

    verify(() => presenter.validateEmail(email));

    final password = faker.internet.password();
    await tester.enterText(find.bySemanticsLabel('Password'), password);

    verify(() => presenter.validatePassword(password));
  });

  testWidgets('simulação de erro para email com campo obrigatório ...',
      (tester) async {
    await loadPage(tester);

    presenter.emitEmailError(UIError.requiredField);
    await tester.pump();

    expect(find.text('Campo obrigatório.'), findsOneWidget);
  });

  testWidgets('simulação de erro para email quando o campo é inválido ...',
      (tester) async {
    await loadPage(tester);

    presenter.emitEmailError(UIError.invalidField);
    await tester.pump();

    expect(find.text('Campo inválido.'), findsOneWidget);
  });

  testWidgets('simulação de erro quando password é invalido ...',
      (tester) async {
    await loadPage(tester);

    presenter.emitEmailError(UIError.requiredField);
    await tester.pump();

    expect(find.text('Campo obrigatório.'), findsOneWidget);
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
    expect(button.onPressed, null);
  });

  testWidgets('Direcionado a autenticação quando o form for submetido...',
      (tester) async {
    await loadPage(tester);

    presenter.emitFormValid();
    await tester.pump();
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    verify(() => presenter.auth()).called(1);
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

  testWidgets('Mensagem de erro quando a autenticação falhar...',
      (tester) async {
    await loadPage(tester);

    presenter.emitMainError(UIError.invalidCredentials);
    await tester.pump();

    expect(find.text('Credenciais inválidas.'), findsOneWidget);
  });

  testWidgets(
      'Mensagem de erro quando a autenticação ter um erro inexperado...',
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

  testWidgets('shpuld call goToSingUp on link click..', (tester) async {
    await loadPage(tester);

    final button = find.text('Adicionar conta');

    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pump();

    verify(() => presenter.goToSingUp()).called(1);
  });
}
