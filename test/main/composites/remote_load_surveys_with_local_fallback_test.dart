import 'package:curso_tdd/domain/entities/survey_entity.dart';
import 'package:curso_tdd/domain/helpers/helpers.dart';
import 'package:curso_tdd/main/composites/composites.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../data/mocks/mocks.dart';
import '../../domain/mocks/mocks.dart';

void main() {
  late RemoteLoadSurveysWithLocalFallback sut;
  late RemoteLoadSurveysSpy remote;
  late LocalLoadSurveysSpy local;
  late List<SurveyEntity> localSurveys;
  late List<SurveyEntity> remoteSurveys;

  setUp(() {
    local = LocalLoadSurveysSpy();
    remote = RemoteLoadSurveysSpy();
    remoteSurveys = EntityFactory.makeSurveyList();
    remote.mockRemoteLoad(remoteSurveys);
    localSurveys = EntityFactory.makeSurveyList();
    local.mockLocalLoad(localSurveys);
    sut = RemoteLoadSurveysWithLocalFallback(remote: remote, local: local);
  });

  test('Should call remote load', () async {
    await sut.load();

    verify(() => remote.load()).called(1);
  });

  test('Should call local save with remote data', () async {
    await sut.load();

    verify(() => local.save(remoteSurveys)).called(1);
  });

  test('Should return remote data', () async {
    final surveys = await sut.load();

    expect(surveys, remoteSurveys);
  });

  test('Should rethrow if remote load throws AccessDeniedError', () async {
    remote.mockRemoteLoadError(DomainError.acessDenied);
    final future = sut.load();

    expect(future, throwsA(DomainError.acessDenied));
  });

  test('Should call local fetch on remote error', () async {
    remote.mockRemoteLoadError(DomainError.unexpected);
    await sut.load();

    verify(() => local.validate()).called(1);
    verify(() => local.load()).called(1);
  });

  test('Should return local surveys', () async {
    remote.mockRemoteLoadError(DomainError.unexpected);
    final surveys = await sut.load();

    expect(surveys, localSurveys);
  });

  test('Should throw UnexpectedError if remote and local throws', () async {
    remote.mockRemoteLoadError(DomainError.unexpected);
    local.mockLocalLoadError();

    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });
}
