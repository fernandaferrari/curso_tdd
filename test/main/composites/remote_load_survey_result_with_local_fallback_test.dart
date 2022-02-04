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
      throw DomainError.acessDenied;
    }
  }
}

void main() {
  RemoteLoadSurveysResultSpy remote;
  LocalLoadSurveyResultSpy local;
  RemoteLoadSurveyResultWithLocalFallback sut;
  SurveyResultEntity surveyResult;

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
    surveyResult = data;

    mockRemoteResultCall().thenAnswer((_) async => surveyResult);
  }

  void mockRemoteError(DomainError error) =>
      mockRemoteResultCall().thenThrow(error);

  setUp(() {
    remote = RemoteLoadSurveysResultSpy();
    local = LocalLoadSurveyResultSpy();
    sut = RemoteLoadSurveyResultWithLocalFallback(remote: remote, local: local);
    mockSurveyResult(mockSurveyData());
  });

  test('Should call remote loadBySurvey and local save with remote data',
      () async {
    await sut.loadBySurvey(surveyId: surveyResult.surveyId);

    verify(remote.loadBySurvey(surveyId: surveyResult.surveyId)).called(1);
    verify(local.save(surveyResult: surveyResult)).called(1);
  });

  test('Should return remote data', () async {
    final response = await sut.loadBySurvey(surveyId: surveyResult.surveyId);

    expect(response, surveyResult);
  });

  test('Should rethrow if remote LoadBySurveys AccessDenied error', () async {
    mockRemoteError(DomainError.acessDenied);

    final future = sut.loadBySurvey(surveyId: surveyResult.surveyId);

    expect(future, throwsA(DomainError.acessDenied));
  });
}
