import 'package:curso_tdd/ui/helpers/helpers.dart';
import 'package:curso_tdd/ui/pages/surveys/surveys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/helpers.dart';
import '../mocks/mocks.dart';

void main() {
  late SurveysPresenterSpy presenter;

  Future<void> loadPage(WidgetTester tester) async {
    presenter = SurveysPresenterSpy();

    await tester.pumpWidget(
        makePage(path: '/surveys', page: () => SurveysPage(presenter)));
  }

  testWidgets('Should call LoadSurveys on page Load ...', (tester) async {
    await loadPage(tester);
    verify(() => presenter.loadData()).called(1);
  });

  testWidgets('Should call LoadSurveys on reload ...', (tester) async {
    await loadPage(tester);
    presenter.emitNavigateTo('/any_route');
    await tester.pumpAndSettle();
    await tester.pageBack();

    verify(() => presenter.loadData()).called(2);
  });

  testWidgets('should handle loading correctly...', (tester) async {
    await loadPage(tester);

    presenter.emitLoading(true);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    presenter.emitLoading(false);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('should presenter error if surveysStream fails...',
      (tester) async {
    await loadPage(tester);

    presenter.emitSurveysError(UIError.unexpected.description);
    await tester.pump();

    expect(find.text('Algo errado aconteceu. Tente novamente em breve.'),
        findsOneWidget);
    expect(find.text('Recarregar'), findsOneWidget);
    expect(find.text('Question 1'), findsNothing);
  });

  testWidgets('should presenter list if surveysStream success...',
      (tester) async {
    await loadPage(tester);

    presenter.emitSurveys(ViewModelFactory.makeSurveys());
    await tester.pump();

    expect(find.text('Algo errado aconteceu. Tente novamente em breve.'),
        findsNothing);
    expect(find.text('Recarregar'), findsNothing);
    expect(find.text('Question 1'), findsWidgets);
    expect(find.text('Question 2'), findsWidgets);
    expect(find.text('Any Date'), findsWidgets);
  });

  testWidgets('Should call LoadSurveys on reload button click ...',
      (tester) async {
    await loadPage(tester);

    presenter.emitSurveysError(UIError.unexpected.description);
    await tester.pump();

    await tester.tap(find.text('Recarregar'));

    verify(() => presenter.loadData()).called(2);
  });

  testWidgets('should call goToSurveyResult on survey click..', (tester) async {
    await loadPage(tester);
    presenter.emitSurveys(ViewModelFactory.makeSurveys());
    await tester.pump();

    await tester.tap(find.text('Question 1'));
    await tester.pump();

    verify(() => presenter.goToSurveyResult('1')).called(1);
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
    expect(currentRoute, '/surveys');

    // presenter.emitNavigateTo(null);
    // await tester.pump();
    // expect(currentRoute, '/surveys');
  });

  testWidgets('Should logout...', (tester) async {
    await loadPage(tester);

    presenter.emitSessionExpired(true);
    await tester.pumpAndSettle();

    expect(currentRoute, '/login');
    expect(find.text('fake login'), findsOneWidget);
  });

  testWidgets('Should not logout...', (tester) async {
    await loadPage(tester);

    presenter.emitNavigateTo('');
    await tester.pump();
    expect(currentRoute, '/surveys');

    // navigateToController.add(null);
    // await tester.pump();
    // expect(currentRoute, '/surveys');
  });
}
