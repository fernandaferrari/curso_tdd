import 'package:curso_tdd/domain/entities/survey_entity.dart';
import 'package:curso_tdd/domain/helpers/helpers.dart';
import 'package:curso_tdd/domain/usecases/load_surveys.dart';
import 'package:curso_tdd/presentation/presenter/getx_surveys_presenter.dart';
import 'package:curso_tdd/ui/helpers/helpers.dart';
import 'package:curso_tdd/ui/pages/surveys/surveys_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../mocks/mocks.dart';

class LoadSurveysSpy extends Mock implements LoadSurveys {}

void main() {
  GetxSurveysPresenter sut;
  LoadSurveysSpy surveysStream;
  List<SurveyEntity> surveys;

  PostExpectation mockLoadCall() => when(surveysStream.load());

  void mockLoadSurveys(List<SurveyEntity> data) {
    surveys = data;
    mockLoadCall().thenAnswer((_) async => surveys);
  }

  void mockLoadSurveysError() =>
      mockLoadCall().thenThrow(DomainError.unexpected);
  void mockAccessDeniedError() =>
      mockLoadCall().thenThrow(DomainError.acessDenied);

  setUp(() {
    surveysStream = LoadSurveysSpy();
    sut = GetxSurveysPresenter(loadSurveysStream: surveysStream);
    mockLoadSurveys(FakeSurveysFactory.makeEntities());
  });

  test('Should call LoadSurveys on loadData', () async {
    await sut.loadData();

    verify(surveysStream.load()).called(1);
  });

  test('Should emit correct events on success', () async {
    expectLater(sut.isLoadStream, emitsInOrder([true, false]));
    sut.surveysStream.listen(expectAsync1((surveys) => expect(surveys, [
          SurveysViewModel(
              id: surveys[0].id,
              question: surveys[0].question,
              date: '02 Feb 2020',
              didAnswer: surveys[0].didAnswer),
          SurveysViewModel(
              id: surveys[1].id,
              question: surveys[1].question,
              date: '02 Mar 2022',
              didAnswer: surveys[1].didAnswer),
        ])));

    await sut.loadData();
  });

  test('Should emit correct events on failure', () async {
    mockLoadSurveysError();
    expectLater(sut.isLoadStream, emitsInOrder([true, false]));
    sut.surveysStream.listen(null,
        onError: expectAsync1(
            (error) => expect(error, UIError.unexpected.description)));

    await sut.loadData();
  });
  test('Should emit correct events on access denied', () async {
    mockAccessDeniedError();
    expectLater(sut.isLoadStream, emitsInOrder([true, false]));
    expectLater(sut.isSessionExpiredStream, emits(true));

    await sut.loadData();
  });

  test('Should go to SurveyResultPage on survey click', () async {
    expectLater(sut.navigateToStream,
        emitsInOrder(['/survey_result/1', '/survey_result/1']));

    sut.goToSurveyResult('1');
    sut.goToSurveyResult('1');
  });
}
