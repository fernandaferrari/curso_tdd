import 'package:curso_tdd/data/usercases/load_surveys/local_load_surveys.dart';
import 'package:curso_tdd/domain/entities/survey_entity.dart';
import 'package:curso_tdd/domain/usecases/load_surveys.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';

import 'package:curso_tdd/data/usercases/usecase.dart';

class RemoteLoadSurveysSpy extends Mock implements RemoteLoadSurveys {}

class LocalLoadSurveysSpy extends Mock implements LocalLoadSurveys {}

class RemoteLoadSurveysWithLocalFallback implements LoadSurveys {
  final RemoteLoadSurveys remote;
  final LocalLoadSurveys local;

  RemoteLoadSurveysWithLocalFallback({
    @required this.remote,
    @required this.local,
  });

  Future<List<SurveyEntity>> load() async {
    final surveys = await remote.load();
    await local.save(surveys);
    return surveys;
  }
}

void main() {
  RemoteLoadSurveysWithLocalFallback sut;
  RemoteLoadSurveysSpy remote;
  LocalLoadSurveysSpy local;

  List<SurveyEntity> remoteSurveys;

  List<SurveyEntity> mockSurveys() => [
        SurveyEntity(
            id: faker.guid.guid(),
            question: faker.randomGenerator.string(10),
            dateTime: faker.date.dateTime(),
            didAnswer: faker.randomGenerator.boolean()),
      ];

  void mockRemoteLoad() {
    remoteSurveys = mockSurveys();
    when(remote.load()).thenAnswer((realInvocation) async => remoteSurveys);
  }

  setUp(() {
    local = LocalLoadSurveysSpy();
    remote = RemoteLoadSurveysSpy();
    sut = RemoteLoadSurveysWithLocalFallback(remote: remote, local: local);
    mockRemoteLoad();
  });

  test('Should call remote load', () async {
    await sut.load();

    verify(remote.load()).called(1);
  });

  test('Should call local save with remote data', () async {
    await sut.load();

    verify(local.save(remoteSurveys)).called(1);
  });

  test('Should return remote data', () async {
    final surveys = await sut.load();

    expect(surveys, remoteSurveys);
  });
}
