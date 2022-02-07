import 'package:curso_tdd/data/usercases/load_surveys_result/load_surveys_result.dart';
import 'package:curso_tdd/domain/entities/survey_result_entity.dart';
import 'package:curso_tdd/domain/helpers/helpers.dart';
import 'package:curso_tdd/main/composites/composites.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../mocks/mocks.dart';

class RemoteLoadSurveysResultSpy extends Mock
    implements RemoteLoadSurveysResult {}

class LocalLoadSurveyResultSpy extends Mock implements LocalLoadSurveyResult {}

void main() {
  RemoteLoadSurveysResultSpy remote;
  LocalLoadSurveyResultSpy local;
  RemoteLoadSurveyResultWithLocalFallback sut;
  SurveyResultEntity remoteResult;
  SurveyResultEntity localResult;

  PostExpectation mockRemoteResultCall() =>
      when(remote.loadBySurvey(surveyId: anyNamed('surveyId')));

  void mockSurveyResult(SurveyResultEntity data) {
    remoteResult = data;

    mockRemoteResultCall().thenAnswer((_) async => remoteResult);
  }

  void mockRemoteError(DomainError error) =>
      mockRemoteResultCall().thenThrow(error);

  PostExpectation mockLoadResultCall() =>
      when(local.loadBySurvey(surveyId: anyNamed('surveyId')));

  void mockLocalSurveyResult(SurveyResultEntity data) {
    localResult = data;

    mockLoadResultCall().thenAnswer((_) async => localResult);
  }

  void mockLocalError() =>
      mockLoadResultCall().thenThrow(DomainError.unexpected);

  setUp(() {
    remote = RemoteLoadSurveysResultSpy();
    local = LocalLoadSurveyResultSpy();
    sut = RemoteLoadSurveyResultWithLocalFallback(remote: remote, local: local);
    mockSurveyResult(FakeSurveyResultFactory.makeSurveyResultEntity());
    mockLocalSurveyResult(FakeSurveyResultFactory.makeSurveyResultEntity());
  });

  test('Should call remote loadBySurvey and local save with remote data',
      () async {
    await sut.loadBySurvey(surveyId: remoteResult.surveyId);

    verify(remote.loadBySurvey(surveyId: remoteResult.surveyId)).called(1);
  });

  test('Should call local save with remote data', () async {
    await sut.loadBySurvey(surveyId: remoteResult.surveyId);

    verify(local.save(surveyResult: remoteResult)).called(1);
  });

  test('Should return remote data', () async {
    final response = await sut.loadBySurvey(surveyId: remoteResult.surveyId);

    expect(response, remoteResult);
  });

  test('Should rethrow if remote LoadBySurveys AccessDenied error', () async {
    mockRemoteError(DomainError.acessDenied);

    final future = sut.loadBySurvey(surveyId: remoteResult.surveyId);

    expect(future, throwsA(DomainError.acessDenied));
  });

  test('Should call local LoadBySurvey on remote error', () async {
    mockRemoteError(DomainError.unexpected);

    await sut.loadBySurvey(surveyId: remoteResult.surveyId);

    verify(local.validate(remoteResult.surveyId)).called(1);
    verify(local.loadBySurvey(surveyId: remoteResult.surveyId)).called(1);
  });

  test('Should return local data', () async {
    mockRemoteError(DomainError.unexpected);

    final response = await sut.loadBySurvey(surveyId: remoteResult.surveyId);

    expect(response, localResult);
  });

  test('Should throw UnexpectError if local fails', () async {
    mockRemoteError(DomainError.unexpected);
    mockLocalError();

    final future = sut.loadBySurvey(surveyId: remoteResult.surveyId);

    expect(future, throwsA(DomainError.unexpected));
  });
}
