import 'dart:async';

import 'package:curso_tdd/ui/pages/pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../helpers/helpers.dart';

class SplashPresenterSpy extends Mock implements SplashPresenter {}

void main() {
  StreamController<String> navigateToController;
  SplashPresenterSpy presenter;

  Future<void> loadPage(WidgetTester tester) async {
    presenter = SplashPresenterSpy();
    navigateToController = StreamController<String>();
    when(presenter.navigateToStream)
        .thenAnswer((_) => navigateToController.stream);

    await tester.pumpWidget(
        makePage(path: '/', page: () => SplashPage(presenter: presenter)));
  }

  tearDown(() {
    navigateToController.close();
  });

  testWidgets('Should present spinner on page load', (tester) async {
    await loadPage(tester);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Should call presenter checkAccount on page load',
      (tester) async {
    await loadPage(tester);

    verify(presenter.checkAccount()).called(1);
  });

  testWidgets('Should load page', (tester) async {
    await loadPage(tester);

    navigateToController.add('/any_route');
    await tester.pumpAndSettle();

    expect(currentRoute, '/any_route');
    expect(find.text('fake page'), findsOneWidget);
  });

  testWidgets('Should not change page', (tester) async {
    await loadPage(tester);

    navigateToController.add('');
    await tester.pump();
    expect(currentRoute, '/');

    navigateToController.add(null);
    await tester.pump();
    expect(currentRoute, '/');
  });
}
