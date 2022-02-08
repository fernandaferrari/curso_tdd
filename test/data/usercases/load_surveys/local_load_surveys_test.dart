import 'package:curso_tdd/data/usercases/load_surveys/local_load_surveys.dart';
import 'package:curso_tdd/domain/entities/survey_entity.dart';
import 'package:curso_tdd/domain/helpers/helpers.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../domain/mocks/mocks.dart';
import '../../../infra/mocks/mocks.dart';
import '../../mocks/mocks.dart';

void main() {
  late CacheStorageSpy cacheStorage;
  late LocalLoadSurveys sut;
  late List<Map> data;

  late List<SurveyEntity> surveys;

  setUp(() {
    cacheStorage = CacheStorageSpy();
    data = CacheFactory.makeSurveyList();
    sut = LocalLoadSurveys(cacheStorage: cacheStorage);
    cacheStorage.mockFetch(data);
    surveys = EntityFactory.makeSurveyList();
  });

  group('load', () {
    test('Should call FetchCacheStorage with correct key', () async {
      await sut.load();

      verify(() => cacheStorage.fetch('surveys')).called(1);
    });

    test('Should return a list of surveys on success', () async {
      final surveys = await sut.load();

      expect(surveys, [
        SurveyEntity(
            id: data[0]['id'],
            question: data[0]['question'],
            dateTime: DateTime.utc(2020, 7, 20),
            didAnswer: false),
        SurveyEntity(
            id: data[1]['id'],
            question: data[1]['question'],
            dateTime: DateTime.utc(2022, 10, 20),
            didAnswer: true)
      ]);
    });

    test('Should throw UnexpectedError if cache is empty', () async {
      cacheStorage.mockFetch([]);

      final future = sut.load();

      expect(future, throwsA(DomainError.unexpected));
    });

    test('Should throw UnexpectedError if cache is invalids', () async {
      cacheStorage.mockFetch(CacheFactory.makeInvalidSurveyList());

      final future = sut.load();

      expect(future, throwsA(DomainError.unexpected));
    });

    test('Should throw UnexpectedError if cache is incomplete', () async {
      cacheStorage.mockFetch(CacheFactory.makeIncompleteSurveyList());

      final future = sut.load();

      expect(future, throwsA(DomainError.unexpected));
    });

    test('Should throw UnexpectedError if cache throws', () async {
      cacheStorage.mockFetchError();

      final future = sut.load();

      expect(future, throwsA(DomainError.unexpected));
    });
  });

  group('validate', () {
    test('Should call cacheStorage with correct key', () async {
      await sut.validate();

      verify(() => cacheStorage.fetch('surveys')).called(1);
    });

    test('Should delete cache if it is invalid', () async {
      cacheStorage.mockFetch(CacheFactory.makeInvalidSurveyList());
      await sut.validate();

      verify(() => cacheStorage.delete('surveys')).called(1);
    });

    test('Should delete cache if it is incomplete', () async {
      cacheStorage.mockFetch(CacheFactory.makeIncompleteSurveyList());
      await sut.validate();

      verify(() => cacheStorage.delete('surveys')).called(1);
    });

    test('Should delete cache if it is throws', () async {
      cacheStorage.mockFetchError();
      await sut.validate();

      verify(() => cacheStorage.delete('surveys')).called(1);
    });
  });

  group('save', () {
    test('Should throw UnexpectedError if save throws', () async {
      final list = [
        {
          'id': surveys[0].id,
          'question': surveys[0].question,
          'didAnswer': 'true',
          'date': "2020-02-02T00:00:00.000Z",
        },
        {
          'id': surveys[1].id,
          'question': surveys[1].question,
          'didAnswer': 'false',
          'date': "2022-03-02T00:00:00.000Z",
        }
      ];

      await sut.save(surveys);

      verify(() => cacheStorage.save(key: 'surveys', value: list)).called(1);
    });

    test('Should call cacheStorage with correct values', () async {
      cacheStorage.mockSaveError();

      final furute = sut.save(surveys);
      expect(furute, throwsA(DomainError.unexpected));
    });
  });
}
