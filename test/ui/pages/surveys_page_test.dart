import 'dart:async';

import 'package:curso_tdd/ui/helpers/helpers.dart';
import 'package:curso_tdd/ui/pages/surveys/surveys.dart';
import 'package:curso_tdd/ui/pages/surveys/surveys_presenter.dart';
import 'package:curso_tdd/ui/pages/surveys/surveys_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';

class SurveysPresenterSpy extends Mock implements SurveysPresenter {}

void main() {
  SurveysPresenterSpy presenter;
  StreamController<bool> isLoadController;
  StreamController<List<SurveysViewModel>> loadSurveysController;
  StreamController<String> navigateToController;
  StreamController<bool> isSessionExpiredController;

  void initStreams() {
    isLoadController = StreamController<bool>();
    loadSurveysController = StreamController<List<SurveysViewModel>>();
    navigateToController = StreamController<String>();
    isSessionExpiredController = StreamController<bool>();
  }

  void mockStreams() {
    when(presenter.isLoadStream).thenAnswer((_) => isLoadController.stream);
    when(presenter.surveysStream)
        .thenAnswer((_) => loadSurveysController.stream);
    when(presenter.navigateToStream)
        .thenAnswer((_) => navigateToController.stream);
    when(presenter.isSessionExpiredStream)
        .thenAnswer((_) => isSessionExpiredController.stream);
  }

  void closeStreams() {
    isLoadController.close();
    loadSurveysController.close();
    navigateToController.close();
    isSessionExpiredController.close();
  }

  Future<void> loadPage(WidgetTester tester) async {
    presenter = SurveysPresenterSpy();

    initStreams();
    mockStreams();

    final surveysPage = GetMaterialApp(
      initialRoute: '/surveys',
      getPages: [
        GetPage(
            name: '/surveys', page: () => SurveysPage(presenter: presenter)),
        GetPage(
            name: '/any_route',
            page: () => Scaffold(
                  body: Text('fake page'),
                )),
        GetPage(
            name: '/login',
            page: () => Scaffold(
                  body: Text('fake login'),
                )),
      ],
    );
    await tester.pumpWidget(surveysPage);
  }

  List<SurveysViewModel> makeSurveys() => [
        SurveysViewModel(
            id: '1', question: 'Question 1', date: 'Any Date', didAnswer: true),
        SurveysViewModel(
            id: '2', question: 'Question 2', date: 'Any Date', didAnswer: false)
      ];

  tearDown(() {
    closeStreams();
  });

  testWidgets('Should call LoadSurveys on page Load ...', (tester) async {
    await loadPage(tester);
    verify(presenter.loadData()).called(1);
  });

  testWidgets('should handle loading correctly...', (tester) async {
    await loadPage(tester);

    isLoadController.add(true);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    isLoadController.add(false);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsNothing);

    isLoadController.add(null);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('should presenter error if surveysStream fails...',
      (tester) async {
    await loadPage(tester);

    loadSurveysController.addError(UIError.unexpected.description);
    await tester.pump();

    expect(find.text('Algo errado aconteceu. Tente novamente em breve.'),
        findsOneWidget);
    expect(find.text('Recarregar'), findsOneWidget);
    expect(find.text('Question 1'), findsNothing);
  });

  testWidgets('should presenter list if surveysStream success...',
      (tester) async {
    await loadPage(tester);

    loadSurveysController.add(makeSurveys());
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

    loadSurveysController.addError(UIError.unexpected.description);
    await tester.pump();

    await tester.tap(find.text('Recarregar'));

    verify(presenter.loadData()).called(2);
  });

  testWidgets('should call goToSurveyResult on survey click..', (tester) async {
    await loadPage(tester);

    loadSurveysController.add(makeSurveys());
    await tester.pump();

    await tester.tap(find.text('Question 1'));
    await tester.pump();

    verify(presenter.goToSurveyResult('1')).called(1);
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
    expect(Get.currentRoute, '/surveys');

    navigateToController.add(null);
    await tester.pump();
    expect(Get.currentRoute, '/surveys');
  });

  testWidgets('Should logout...', (tester) async {
    await loadPage(tester);

    isSessionExpiredController.add(true);
    await tester.pumpAndSettle();

    expect(Get.currentRoute, '/login');
    expect(find.text('fake login'), findsOneWidget);
  });

  testWidgets('Should not logout...', (tester) async {
    await loadPage(tester);

    navigateToController.add('');
    await tester.pump();
    expect(Get.currentRoute, '/surveys');

    navigateToController.add(null);
    await tester.pump();
    expect(Get.currentRoute, '/surveys');
  });
}
