import 'package:curso_tdd/domain/entities/survey_answer_entity.dart';
import 'package:curso_tdd/domain/entities/survey_result_entity.dart';
import 'package:curso_tdd/domain/helpers/helpers.dart';
import 'package:curso_tdd/domain/usecases/load_survey_result.dart';
import 'package:curso_tdd/presentation/presenter/presenter.dart';
import 'package:curso_tdd/ui/helpers/helpers.dart';
import 'package:curso_tdd/ui/pages/pages.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class LoadSurveysResultSpy extends Mock implements LoadSurveyResult {}

void main() {
  GetxSurveyResultPresenter sut;
  LoadSurveysResultSpy loadSurveyResultStream;
  SurveyResultEntity surveys;
  String surveyId;

  SurveyResultEntity mockValidData() => SurveyResultEntity(
          surveyId: faker.guid.guid(),
          question: faker.lorem.sentence(),
          answers: [
            SurveyAnswerEntity(
              image: faker.internet.httpUrl(),
              answer: faker.lorem.sentence(),
              isCurrentAnswer: faker.randomGenerator.boolean(),
              percent: faker.randomGenerator.integer(100),
            ),
            SurveyAnswerEntity(
              answer: faker.lorem.sentence(),
              isCurrentAnswer: faker.randomGenerator.boolean(),
              percent: faker.randomGenerator.integer(100),
            )
          ]);

  PostExpectation mockLoadCall() =>
      when(loadSurveyResultStream.loadBySurvey(surveyId: anyNamed('surveyId')));

  void mockLoadSurveys(SurveyResultEntity data) {
    surveys = data;
    mockLoadCall().thenAnswer((_) async => surveys);
  }

  void mockLoadSurveysError() =>
      mockLoadCall().thenThrow(DomainError.unexpected);

  setUp(() {
    surveyId = faker.guid.guid();
    loadSurveyResultStream = LoadSurveysResultSpy();
    sut = GetxSurveyResultPresenter(
        loadSurveyResultStream: loadSurveyResultStream, surveyId: surveyId);
    mockLoadSurveys(mockValidData());
  });

  test('Should call LoadSurveyResult on loadData', () async {
    await sut.loadData();

    verify(loadSurveyResultStream.loadBySurvey(surveyId: surveyId)).called(1);
  });

  test('Should emit correct events on success', () async {
    expectLater(sut.isLoadStream, emitsInOrder([true, false]));
    sut.surveysResultStream.listen(expectAsync1((result) => expect(
          result,
          SurveysResultViewModel(
              surveyId: surveys.surveyId,
              question: surveys.question,
              answers: [
                SurveyAnswerViewModel(
                    image: surveys.answers[0].image,
                    answer: surveys.answers[0].answer,
                    isCurrentAnswer: surveys.answers[0].isCurrentAnswer,
                    percent: '${surveys.answers[0].percent}'),
                SurveyAnswerViewModel(
                    answer: surveys.answers[1].answer,
                    isCurrentAnswer: surveys.answers[1].isCurrentAnswer,
                    percent: '${surveys.answers[1].percent}')
              ]),
        )));

    await sut.loadData();
  });

  test('Should emit correct events on failure', () async {
    mockLoadSurveysError();
    expectLater(sut.isLoadStream, emitsInOrder([true, false]));
    sut.surveysResultStream.listen(null,
        onError: expectAsync1(
            (error) => expect(error, UIError.unexpected.description)));

    await sut.loadData();
  });
}
