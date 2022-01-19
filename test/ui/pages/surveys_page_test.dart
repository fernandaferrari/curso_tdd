import 'dart:async';

import 'package:curso_tdd/ui/pages/surveys/surveys.dart';
import 'package:curso_tdd/ui/pages/surveys/surveys_presenter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';

class SurveysPresenterSpy extends Mock implements SurveysPresenter {}

void main() {
  SurveysPresenterSpy presenter;
  StreamController<bool> isLoadController;

  void initStreams() {
    isLoadController = StreamController<bool>();
  }

  void mockStreams() {
    when(presenter.isLoadStream).thenAnswer((_) => isLoadController.stream);
  }

  void closeStreams() {
    isLoadController.close();
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
}
