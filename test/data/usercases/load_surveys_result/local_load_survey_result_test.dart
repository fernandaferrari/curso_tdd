import 'package:curso_tdd/data/cache/cache.dart';
import 'package:curso_tdd/data/usercases/load_surveys_result/local_load_survey_result.dart';
import 'package:curso_tdd/domain/entities/entities.dart';
import 'package:curso_tdd/domain/helpers/helpers.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../mocks/mocks.dart';

class CacheStorageSpy extends Mock implements CacheStorage {}

void main() {
  group('loadBySurveys', () {
    CacheStorageSpy cacheStorage;
    LocalLoadSurveyResult sut;
    Map data;
    String surveyId;

    PostExpectation mockFetchCall() => when(cacheStorage.fetch(any));

    void mockFetch(Map json) {
      data = json;
      mockFetchCall().thenAnswer((_) async => data);
    }

    void mockFetchError() => mockFetchCall().thenThrow(Exception());

    setUp(() {
      surveyId = faker.guid.guid();
      cacheStorage = CacheStorageSpy();
      sut = LocalLoadSurveyResult(cacheStorage: cacheStorage);
      mockFetch(FakeSurveyResultFactory.makeCacheJson());
    });

    test('Should call FetchCacheStorage with correct key', () async {
      await sut.loadBySurvey(surveyId: surveyId);

      verify(cacheStorage.fetch('survey_result/$surveyId')).called(1);
    });

    test('Should return surveyResult on success', () async {
      final surveysResult = await sut.loadBySurvey(surveyId: surveyId);

      expect(
          surveysResult,
          SurveyResultEntity(
              surveyId: data['surveyId'],
              question: data['question'],
              answers: [
                SurveyAnswerEntity(
                    image: data['answers'][0]['image'],
                    answer: data['answers'][0]['answer'],
                    isCurrentAnswer: true,
                    percent: 40),
                SurveyAnswerEntity(
                    answer: data['answers'][1]['answer'],
                    isCurrentAnswer: false,
                    percent: 60)
              ]));
    });

    test('Should throw UnexpectedError if cache is empty', () async {
      mockFetch({});

      final future = sut.loadBySurvey(surveyId: surveyId);

      expect(future, throwsA(DomainError.unexpected));
    });

    test('Should throw UnexpectedError if cache is null', () async {
      mockFetch(null);

      final future = sut.loadBySurvey(surveyId: surveyId);

      expect(future, throwsA(DomainError.unexpected));
    });

    test('Should throw UnexpectedError if cache is invalids', () async {
      mockFetch(FakeSurveyResultFactory.makeInvalidJson());

      final future = sut.loadBySurvey(surveyId: surveyId);

      expect(future, throwsA(DomainError.unexpected));
    });

    test('Should throw UnexpectedError if cache is incomplete', () async {
      mockFetch(FakeSurveyResultFactory.makeIncompleteCacheJson());

      final future = sut.loadBySurvey(surveyId: surveyId);

      expect(future, throwsA(DomainError.unexpected));
    });

    test('Should throw UnexpectedError if cache throws', () async {
      mockFetchError();

      final future = sut.loadBySurvey(surveyId: surveyId);

      expect(future, throwsA(DomainError.unexpected));
    });
  });

  group('validate', () {
    CacheStorageSpy cacheStorage;
    LocalLoadSurveyResult sut;
    Map data;
    String surveyId;

    PostExpectation mockFetchCall() => when(cacheStorage.fetch(any));

    void mockFetch(Map json) {
      data = json;
      mockFetchCall().thenAnswer((_) async => data);
    }

    void mockFetchError() => mockFetchCall().thenThrow(Exception());

    setUp(() {
      surveyId = faker.guid.guid();
      cacheStorage = CacheStorageSpy();
      sut = LocalLoadSurveyResult(
        cacheStorage: cacheStorage,
      );
      mockFetch(FakeSurveyResultFactory.makeCacheJson());
    });

    test('Should call cacheStorage with correct key', () async {
      await sut.validate(surveyId);

      verify(cacheStorage.fetch('survey_result/$surveyId')).called(1);
    });

    test('Should delete cache if it is invalid', () async {
      mockFetch(FakeSurveyResultFactory.makeInvalidJson());

      await sut.validate(surveyId);

      verify(cacheStorage.delete('survey_result/$surveyId')).called(1);
    });

    test('Should delete cache if it is incomplete', () async {
      mockFetch(FakeSurveyResultFactory.makeIncompleteCacheJson());
      await sut.validate(surveyId);

      verify(cacheStorage.delete('survey_result/$surveyId')).called(1);
    });

    test('Should delete cache if it is throws', () async {
      mockFetchError();
      await sut.validate(surveyId);

      verify(cacheStorage.delete('survey_result/$surveyId')).called(1);
    });
  });

  group('save', () {
    CacheStorageSpy cacheStorage;
    LocalLoadSurveyResult sut;
    SurveyResultEntity surveyResult;

    PostExpectation mockSaveCall() =>
        when(cacheStorage.save(key: anyNamed("key"), value: anyNamed("value")));

    void mockSaveError() => mockSaveCall().thenThrow(Exception());

    setUp(() {
      cacheStorage = CacheStorageSpy();
      sut = LocalLoadSurveyResult(cacheStorage: cacheStorage);
      surveyResult = FakeSurveyResultFactory.makeSurveyResultEntity();
    });

    test('Should throw UnexpectedError if save throws', () async {
      final json = {
        'surveyId': surveyResult.surveyId,
        'question': surveyResult.question,
        'answers': [
          {
            'image': surveyResult.answers[0].image,
            'answer': surveyResult.answers[0].answer,
            'percent': '40',
            'isCurrentAnswer': 'true'
          },
          {
            'image': null,
            'answer': surveyResult.answers[1].answer,
            'percent': '60',
            'isCurrentAnswer': 'false'
          }
        ],
      };

      await sut.save(surveyResult: surveyResult);

      verify(cacheStorage.save(
              key: "survey_result/${surveyResult.surveyId}", value: json))
          .called(1);
    });

    test('Should call cacheStorage with correct values', () async {
      mockSaveError();

      final furute = sut.save(surveyResult: surveyResult);
      expect(furute, throwsA(DomainError.unexpected));
    });
  });
}
