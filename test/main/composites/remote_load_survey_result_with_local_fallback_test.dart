import 'package:curso_tdd/domain/entities/survey_result_entity.dart';
import 'package:curso_tdd/domain/helpers/helpers.dart';
import 'package:curso_tdd/main/composites/composites.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../data/mocks/mocks.dart';
import '../../domain/mocks/mocks.dart';

void main() {
  late RemoteLoadSurveysResultSpy remote;
  late LocalLoadSurveyResultSpy local;
  late RemoteLoadSurveyResultWithLocalFallback sut;
  late SurveyResultEntity remoteResult;
  late SurveyResultEntity localResult;

  setUp(() {
    remote = RemoteLoadSurveysResultSpy();
    local = LocalLoadSurveyResultSpy();
    remoteResult = EntityFactory.makeSurveyResult();
    localResult = EntityFactory.makeSurveyResult();
    remote.mockSurveyResult(remoteResult);
    local.mockLocalSurveyResult(localResult);
    sut = RemoteLoadSurveyResultWithLocalFallback(remote: remote, local: local);
  });

  setUpAll(() {
    registerFallbackValue(EntityFactory.makeSurveyResult());
  });

  test('Should call remote loadBySurvey and local save with remote data',
      () async {
    await sut.loadBySurvey(surveyId: remoteResult.surveyId);

    verify(() => remote.loadBySurvey(surveyId: remoteResult.surveyId))
        .called(1);
  });

  test('Should call local save with remote data', () async {
    await sut.loadBySurvey(surveyId: remoteResult.surveyId);

    verify(() => local.save(surveyResult: remoteResult)).called(1);
  });

  test('Should return remote data', () async {
    final response = await sut.loadBySurvey(surveyId: remoteResult.surveyId);

    expect(response, remoteResult);
  });

  test('Should rethrow if remote LoadBySurveys AccessDenied error', () async {
    remote.mockRemoteError(DomainError.acessDenied);

    final future = sut.loadBySurvey(surveyId: remoteResult.surveyId);

    expect(future, throwsA(DomainError.acessDenied));
  });

  test('Should call local LoadBySurvey on remote error', () async {
    remote.mockRemoteError(DomainError.unexpected);

    await sut.loadBySurvey(surveyId: remoteResult.surveyId);

    verify(() => local.validate(remoteResult.surveyId)).called(1);
    verify(() => local.loadBySurvey(surveyId: remoteResult.surveyId)).called(1);
  });

  test('Should return local data', () async {
    remote.mockRemoteError(DomainError.unexpected);

    final response = await sut.loadBySurvey(surveyId: remoteResult.surveyId);

    expect(response, localResult);
  });

  test('Should throw UnexpectError if local fails', () async {
    remote.mockRemoteError(DomainError.unexpected);
    local.mockLocalError();

    final future = sut.loadBySurvey(surveyId: remoteResult.surveyId);

    expect(future, throwsA(DomainError.unexpected));
  });
}
