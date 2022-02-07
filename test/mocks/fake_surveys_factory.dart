import 'package:curso_tdd/domain/entities/survey_entity.dart';
import 'package:faker/faker.dart';

class FakeSurveysFactory {
  static List<Map> makeCacheJson() => [
        {
          'id': faker.guid.guid(),
          'question': faker.randomGenerator.string(10),
          'date': "2020-07-20T00:00:00Z",
          'didAnswer': 'false'
        },
        {
          'id': faker.guid.guid(),
          'question': faker.randomGenerator.string(10),
          'date': "2022-10-20T00:00:00Z",
          'didAnswer': 'true'
        }
      ];

  static List<Map> makeInvalidCacheJson() => [
        {
          'id': faker.guid.guid(),
          'question': faker.randomGenerator.string(10),
          'date': "invalid date",
          'didAnswer': 'false'
        }
      ];

  static List<Map> makeIncompleteCacheJson() => [
        {'date': "2022-10-20T00:00:00Z", 'didAnswer': 'false'}
      ];

  static List<SurveyEntity> makeEntities() => [
        SurveyEntity(
            id: faker.guid.guid(),
            question: faker.randomGenerator.string(50),
            dateTime: DateTime.utc(2020, 2, 2),
            didAnswer: true),
        SurveyEntity(
            id: faker.guid.guid(),
            question: faker.randomGenerator.string(50),
            dateTime: DateTime.utc(2022, 3, 2),
            didAnswer: false)
      ];

  static List<dynamic> makeApiJson() => [
        {
          'id': faker.guid.guid(),
          'question': faker.randomGenerator.string(50),
          'didAnswer': faker.randomGenerator.boolean(),
          'date': faker.date.dateTime().toIso8601String(),
        },
        {
          'id': faker.guid.guid(),
          'question': faker.randomGenerator.string(50),
          'didAnswer': faker.randomGenerator.boolean(),
          'date': faker.date.dateTime().toIso8601String(),
        }
      ];

  static List<Map> makeInvalidApiJson() => [
        {'invalid_key': 'invalid_value'}
      ];
}
