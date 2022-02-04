import 'package:curso_tdd/domain/entities/survey_answer_entity.dart';
import 'package:curso_tdd/domain/entities/survey_result_entity.dart';
import 'package:curso_tdd/domain/helpers/helpers.dart';
import 'package:curso_tdd/domain/usecases/load_survey_result.dart';
import 'package:curso_tdd/domain/usecases/usecases.dart';
import 'package:curso_tdd/presentation/presenter/presenter.dart';
import 'package:curso_tdd/ui/helpers/helpers.dart';
import 'package:curso_tdd/ui/pages/pages.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class LoadSurveysResultSpy extends Mock implements LoadSurveyResult {}

class SaveSurveysResultSpy extends Mock implements SaveSurveyResult {}

void main() {
  GetxSurveyResultPresenter sut;
  LoadSurveysResultSpy loadSurveyResultStream;
  SaveSurveysResultSpy saveSurveyResult;
  SurveyResultEntity loadResult;
  SurveyResultEntity saveResult;
  String surveyId;
  String answer;

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
    loadResult = data;
    mockLoadCall().thenAnswer((_) async => loadResult);
  }

  void mockLoadSurveysError(DomainError error) =>
      mockLoadCall().thenThrow(error);

  PostExpectation mockSaveCall() =>
      when(saveSurveyResult.save(answer: anyNamed('answer')));

  void mockSaveResult(SurveyResultEntity data) {
    saveResult = data;
    mockSaveCall().thenAnswer((_) async => loadResult);
  }

  void mockSaveurveysError(DomainError error) =>
      mockSaveCall().thenThrow(error);

  setUp(() {
    answer = faker.lorem.sentence();
    surveyId = faker.guid.guid();
    saveSurveyResult = SaveSurveysResultSpy();
    loadSurveyResultStream = LoadSurveysResultSpy();
    sut = GetxSurveyResultPresenter(
        loadSurveyResultStream: loadSurveyResultStream,
        saveSurveyResult: saveSurveyResult,
        surveyId: surveyId);
    mockLoadSurveys(mockValidData());
    mockSaveResult(mockValidData());
  });

  group('loadData', () {
    test('Should call LoadSurveyResult on loadData', () async {
      await sut.loadData();

      verify(loadSurveyResultStream.loadBySurvey(surveyId: surveyId)).called(1);
    });

    test('Should emit correct events on success', () async {
      expectLater(sut.isLoadStream, emitsInOrder([true, false]));
      sut.surveysResultStream.listen(expectAsync1((result) => expect(
            result,
            SurveysResultViewModel(
                surveyId: loadResult.surveyId,
                question: loadResult.question,
                answers: [
                  SurveyAnswerViewModel(
                      image: loadResult.answers[0].image,
                      answer: loadResult.answers[0].answer,
                      isCurrentAnswer: loadResult.answers[0].isCurrentAnswer,
                      percent: '${loadResult.answers[0].percent}'),
                  SurveyAnswerViewModel(
                      image: null,
                      answer: loadResult.answers[1].answer,
                      isCurrentAnswer: loadResult.answers[1].isCurrentAnswer,
                      percent: '${loadResult.answers[1].percent}')
                ]),
          )));

      await sut.loadData();
    });

    test('Should emit correct events on failure', () async {
      mockLoadSurveysError(DomainError.unexpected);
      expectLater(sut.isLoadStream, emitsInOrder([true, false]));
      sut.surveysResultStream.listen(null,
          onError: expectAsync1(
              (error) => expect(error, UIError.unexpected.description)));

      await sut.loadData();
    });

    test('Should emit correct events on access denied', () async {
      mockLoadSurveysError(DomainError.acessDenied);
      expectLater(sut.isLoadStream, emitsInOrder([true, false]));
      expectLater(sut.isSessionExpiredStream, emits(true));

      await sut.loadData();
    });
  });

  group('save', () {
    test('Should call LoadSurveyResult on loadData', () async {
      await sut.save(answer: answer);

      verify(saveSurveyResult.save(answer: answer)).called(1);
    });

    test('Should emit correct events on success', () async {
      expectLater(sut.isLoadStream, emitsInOrder([true, false]));
      sut.surveysResultStream.listen(expectAsync1((result) => expect(
            result,
            SurveysResultViewModel(
                surveyId: saveResult.surveyId,
                question: saveResult.question,
                answers: [
                  SurveyAnswerViewModel(
                      image: saveResult.answers[0].image,
                      answer: saveResult.answers[0].answer,
                      isCurrentAnswer: saveResult.answers[0].isCurrentAnswer,
                      percent: '${saveResult.answers[0].percent}'),
                  SurveyAnswerViewModel(
                      image: null,
                      answer: saveResult.answers[1].answer,
                      isCurrentAnswer: saveResult.answers[1].isCurrentAnswer,
                      percent: '${saveResult.answers[1].percent}')
                ]),
          )));

      await sut.save(answer: answer);
    });

    test('Should emit correct events on failure', () async {
      mockSaveurveysError(DomainError.unexpected);

      expectLater(sut.isLoadStream, emitsInOrder([true, false]));
      sut.surveysResultStream.listen(null,
          onError: expectAsync1(
              (error) => expect(error, UIError.unexpected.description)));

      await sut.save(answer: answer);
    });

    test('Should emit correct events on access denied', () async {
      mockSaveurveysError(DomainError.acessDenied);
      expectLater(sut.isLoadStream, emitsInOrder([true, false]));
      expectLater(sut.isSessionExpiredStream, emits(true));

      await sut.save(answer: answer);
    });
  });
}
