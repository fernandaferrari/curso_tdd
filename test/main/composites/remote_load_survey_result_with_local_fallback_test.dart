import 'package:curso_tdd/data/usercases/load_surveys_result/load_surveys_result.dart';
import 'package:curso_tdd/domain/entities/survey_answer_entity.dart';
import 'package:curso_tdd/domain/entities/survey_result_entity.dart';
import 'package:curso_tdd/domain/helpers/helpers.dart';
import 'package:curso_tdd/domain/usecases/usecases.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class RemoteLoadSurveysResultSpy extends Mock
    implements RemoteLoadSurveysResult {}

class LocalLoadSurveyResultSpy extends Mock implements LocalLoadSurveyResult {}

class RemoteLoadSurveyResultWithLocalFallback implements LoadSurveyResult {
  final RemoteLoadSurveysResult remote;
  final LocalLoadSurveyResult local;

  RemoteLoadSurveyResultWithLocalFallback({this.remote, this.local});

  @override
  Future<SurveyResultEntity> loadBySurvey({String surveyId}) async {
    try {
      final surveyResult = await remote.loadBySurvey(surveyId: surveyId);
      await local.save(surveyResult: surveyResult);
      return surveyResult;
    } catch (error) {
      if (error == DomainError.acessDenied) {
        rethrow;
      } else {
        await local.validate(surveyId);
        return await local.loadBySurvey(surveyId: surveyId);
      }
    }
  }
}

void main() {
  RemoteLoadSurveysResultSpy remote;
  LocalLoadSurveyResultSpy local;
  RemoteLoadSurveyResultWithLocalFallback sut;
  SurveyResultEntity remoteResult;
  SurveyResultEntity localResult;

  mockSurveyData() => SurveyResultEntity(
          surveyId: faker.guid.guid(),
          question: faker.lorem.sentence(),
          answers: [
            SurveyAnswerEntity(
                image: faker.internet.httpUrl(),
                answer: faker.lorem.sentence(),
                isCurrentAnswer: true,
                percent: 40),
            SurveyAnswerEntity(
                image: null,
                answer: faker.lorem.sentence(),
                isCurrentAnswer: false,
                percent: 60)
          ]);

  PostExpectation mockRemoteResultCall() =>
      when(remote.loadBySurvey(surveyId: anyNamed('surveyId')));

  void mockSurveyResult(SurveyResultEntity data) {
    remoteResult = data;

    mockRemoteResultCall().thenAnswer((_) async => localResult);
  }

  void mockRemoteError(DomainError error) =>
      mockRemoteResultCall().thenThrow(error);

  PostExpectation mockLoadResultCall() =>
      when(local.loadBySurvey(surveyId: anyNamed('surveyId')));

  void mockLocalSurveyResult(SurveyResultEntity data) {
    localResult = data;

    mockLoadResultCall().thenAnswer((_) async => remoteResult);
  }

  void mockLocalError() =>
      mockLoadResultCall().thenThrow(DomainError.unexpected);

  setUp(() {
    remote = RemoteLoadSurveysResultSpy();
    local = LocalLoadSurveyResultSpy();
    sut = RemoteLoadSurveyResultWithLocalFallback(remote: remote, local: local);
    mockSurveyResult(mockSurveyData());
    mockLocalSurveyResult(mockSurveyData());
  });

  test('Should call remote loadBySurvey and local save with remote data',
      () async {
    await sut.loadBySurvey(surveyId: remoteResult.surveyId);

    verify(remote.loadBySurvey(surveyId: remoteResult.surveyId)).called(1);
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
