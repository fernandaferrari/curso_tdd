import 'package:curso_tdd/data/usercases/load_surveys_result/local_load_survey_result.dart';
import 'package:curso_tdd/domain/entities/entities.dart';
import 'package:curso_tdd/domain/helpers/helpers.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../domain/mocks/mocks.dart';
import '../../../infra/mocks/mocks.dart';
import '../../mocks/mocks.dart';

void main() {
  late SurveyResultEntity surveyResult;
  late CacheStorageSpy cacheStorage;
  late LocalLoadSurveyResult sut;
  late Map data;
  late String surveyId;

  setUp(() {
    data = CacheFactory.makeSurveyResult();
    surveyId = faker.guid.guid();
    surveyResult = EntityFactory.makeSurveyResult();
    cacheStorage = CacheStorageSpy();
    sut = LocalLoadSurveyResult(cacheStorage: cacheStorage);
    cacheStorage.mockFetch(data);
  });

  group('loadBySurveys', () {
    test('Should call FetchCacheStorage with correct key', () async {
      await sut.loadBySurvey(surveyId: surveyId);

      verify(() => cacheStorage.fetch('survey_result/$surveyId')).called(1);
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
                    image: null,
                    answer: data['answers'][1]['answer'],
                    isCurrentAnswer: false,
                    percent: 60)
              ]));
    });

    test('Should throw UnexpectedError if cache is empty', () async {
      cacheStorage.mockFetch({});

      final future = sut.loadBySurvey(surveyId: surveyId);

      expect(future, throwsA(DomainError.unexpected));
    });

    test('Should throw UnexpectedError if cache is invalids', () async {
      cacheStorage.mockFetch(CacheFactory.makeInvalidSurveyResult());

      final future = sut.loadBySurvey(surveyId: surveyId);

      expect(future, throwsA(DomainError.unexpected));
    });

    test('Should throw UnexpectedError if cache is incomplete', () async {
      cacheStorage.mockFetch(CacheFactory.makeIncompleteSurveyResult());

      final future = sut.loadBySurvey(surveyId: surveyId);

      expect(future, throwsA(DomainError.unexpected));
    });

    test('Should throw UnexpectedError if cache throws', () async {
      cacheStorage.mockFetchError();

      final future = sut.loadBySurvey(surveyId: surveyId);

      expect(future, throwsA(DomainError.unexpected));
    });
  });

  group('validate', () {
    test('Should call cacheStorage with correct key', () async {
      await sut.validate(surveyId);

      verify(() => cacheStorage.fetch('survey_result/$surveyId')).called(1);
    });

    test('Should delete cache if it is invalid', () async {
      cacheStorage.mockFetch(CacheFactory.makeInvalidSurveyResult());

      await sut.validate(surveyId);

      verify(() => cacheStorage.delete('survey_result/$surveyId')).called(1);
    });

    test('Should delete cache if it is incomplete', () async {
      cacheStorage.mockFetch(CacheFactory.makeIncompleteSurveyResult());
      await sut.validate(surveyId);

      verify(() => cacheStorage.delete('survey_result/$surveyId')).called(1);
    });

    test('Should delete cache if it is throws', () async {
      cacheStorage.mockFetchError();
      await sut.validate(surveyId);

      verify(() => cacheStorage.delete('survey_result/$surveyId')).called(1);
    });
  });

  group('save', () {
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

      verify(() => cacheStorage.save(
          key: "survey_result/${surveyResult.surveyId}",
          value: json)).called(1);
    });

    test('Should call cacheStorage with correct values', () async {
      cacheStorage.mockSaveError();

      final furute = sut.save(surveyResult: surveyResult);
      expect(furute, throwsA(DomainError.unexpected));
    });
  });
}
