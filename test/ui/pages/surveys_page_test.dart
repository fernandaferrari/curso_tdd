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

  void initStreams() {
    isLoadController = StreamController<bool>();
    loadSurveysController = StreamController<List<SurveysViewModel>>();
  }

  void mockStreams() {
    when(presenter.isLoadStream).thenAnswer((_) => isLoadController.stream);
    when(presenter.loadSurveys).thenAnswer((_) => loadSurveysController.stream);
  }

  void closeStreams() {
    isLoadController.close();
    loadSurveysController.close();
  }

  Future<void> loadPage(WidgetTester tester) async {
    presenter = SurveysPresenterSpy();

    initStreams();
    mockStreams();

    final surveysPage = GetMaterialApp(
      initialRoute: '/surveys',
      getPages: [
        GetPage(name: '/surveys', page: () => SurveysPage(presenter: presenter))
      ],
    );
    await tester.pumpWidget(surveysPage);
  }

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

  testWidgets('should presenter error if loadSurveysStream fails...',
      (tester) async {
    await loadPage(tester);

    loadSurveysController.addError(UIError.unexpected.description);
    await tester.pump();

    expect(find.text('Algo errado aconteceu. Tente novamente em breve.'),
        findsOneWidget);
    expect(find.text('Recarregar'), findsOneWidget);
    expect(find.text('Question 1'), findsNothing);
  });
}
