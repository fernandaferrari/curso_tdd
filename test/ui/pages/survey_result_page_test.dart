import 'dart:async';

import 'package:curso_tdd/ui/helpers/helpers.dart';
import 'package:curso_tdd/ui/pages/pages.dart';
import 'package:curso_tdd/ui/pages/survey_result/components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_test_utils/image_test_utils.dart';
import 'package:mockito/mockito.dart';

import '../../mocks/mocks.dart';
import '../helpers/helpers.dart';

class SurveyResultPresenterSpy extends Mock implements SurveyResultPresenter {}

void main() {
  SurveyResultPresenterSpy presenter;
  StreamController<bool> isLoadController;
  StreamController<SurveysResultViewModel> surveyResultController;
  StreamController<bool> isSessionExpiredController;

  void initStreams() {
    isLoadController = StreamController<bool>();
    surveyResultController = StreamController<SurveysResultViewModel>();

    isSessionExpiredController = StreamController<bool>();
  }

  void mockStreams() {
    when(presenter.isLoadStream).thenAnswer((_) => isLoadController.stream);
    when(presenter.surveysResultStream)
        .thenAnswer((_) => surveyResultController.stream);
    when(presenter.isSessionExpiredStream)
        .thenAnswer((_) => isSessionExpiredController.stream);
  }

  void closeStreams() {
    isLoadController.close();
    surveyResultController.close();
    isSessionExpiredController.close();
  }

  Future<void> loadPage(WidgetTester tester) async {
    presenter = SurveyResultPresenterSpy();

    initStreams();
    mockStreams();
    await provideMockedNetworkImages(() async {
      await tester.pumpWidget(makePage(
          path: '/survey_result/any_survey_id',
          page: () => SurveyResultPage(presenter: presenter)));
    });
  }

  tearDown(() {
    closeStreams();
  });

  testWidgets('Should call LoadSurveysResult on page Load ...', (tester) async {
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

    surveyResultController.addError(UIError.unexpected.description);
    await tester.pump();

    expect(find.text('Algo errado aconteceu. Tente novamente em breve.'),
        findsOneWidget);
    expect(find.text('Recarregar'), findsOneWidget);
    expect(find.text('Question'), findsNothing);
  });

  testWidgets('Should call LoadSurveys on reload button click ...',
      (tester) async {
    await loadPage(tester);

    surveyResultController.addError(UIError.unexpected.description);
    await tester.pump();

    await tester.tap(find.text('Recarregar'));

    verify(presenter.loadData()).called(2);
  });

  testWidgets('should presenter valid data if surveysStream success...',
      (tester) async {
    await loadPage(tester);

    surveyResultController.add(FakeSurveyResultFactory.makeViewModel());

    await provideMockedNetworkImages(() async {
      await tester.pump();
    });

    expect(find.text('Algo errado aconteceu. Tente novamente em breve.'),
        findsNothing);
    expect(find.text('Recarregar'), findsNothing);
    expect(find.text('Question'), findsOneWidget);
    expect(find.text('Answer 0'), findsOneWidget);
    expect(find.text('Answer 1'), findsOneWidget);
    expect(find.text('60%'), findsOneWidget);
    expect(find.text('40%'), findsOneWidget);
    expect(find.byType(ActiveIcon), findsOneWidget);
    expect(find.byType(DisableIcon), findsOneWidget);
    final image =
        tester.widget<Image>(find.byType(Image)).image as NetworkImage;
    expect(image.url, 'Image 0');
  });

  testWidgets('Should call save on list item click ...', (tester) async {
    await loadPage(tester);

    surveyResultController.add(FakeSurveyResultFactory.makeViewModel());

    await provideMockedNetworkImages(() async {
      await tester.pump();
    });

    await tester.tap(find.text('Answer 1'));

    verify(presenter.save(answer: 'Answer 1')).called(1);
  });

  testWidgets('Should not call save on current answer click ...',
      (tester) async {
    await loadPage(tester);

    surveyResultController.add(FakeSurveyResultFactory.makeViewModel());

    await provideMockedNetworkImages(() async {
      await tester.pump();
    });

    await tester.tap(find.text('Answer 0'));

    verifyNever(presenter.save(answer: 'Answer 0'));
  });
}
