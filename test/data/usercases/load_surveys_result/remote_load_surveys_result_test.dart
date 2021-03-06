import 'package:curso_tdd/data/usercases/load_surveys_result/load_surveys_result.dart';
import 'package:curso_tdd/domain/entities/entities.dart';
import 'package:curso_tdd/domain/helpers/helpers.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:curso_tdd/data/http/http.dart';

import '../../../infra/mocks/mocks.dart';

class HttpClientSpy extends Mock implements IHttpClient {}

void main() {
  late RemoteLoadSurveysResult sut;
  late HttpClientSpy httpClient;
  late String url;
  late Map surveyResult;
  late String surveyId;

  When mockRequestCall() => when(() => httpClient.request(
      url: any(named: "url"),
      method: any(named: "method"),
      body: any(named: "body"),
      headers: any(named: "headers")));
  void mockHttpData(dynamic data) {
    surveyResult = data;
    mockRequestCall().thenAnswer((_) async => data);
  }

  void mockHttpError(HttpError error) => mockRequestCall().thenThrow(error);

  setUp(() {
    surveyId = faker.guid.guid();
    url = faker.internet.httpUrl();
    httpClient = HttpClientSpy();
    sut = RemoteLoadSurveysResult(url: url, httpClient: httpClient);
    mockHttpData(ApiFactory.makeSurveyResult());
  });

  test('Should call HttClient with correct values', () async {
    sut.loadBySurvey(surveyId: surveyId);

    verify(() => httpClient.request(url: url, method: 'get'));
  });

  test('Should return surveysResult on 200', () async {
    final result = await sut.loadBySurvey(surveyId: surveyId);

    expect(
        result,
        SurveyResultEntity(
            surveyId: surveyResult['surveyId'],
            question: surveyResult['question'],
            answers: [
              SurveyAnswerEntity(
                image: surveyResult['answers'][0]['image'],
                answer: surveyResult['answers'][0]['answer'],
                isCurrentAnswer: surveyResult['answers'][0]
                    ['isCurrentAccountAnswer'],
                percent: surveyResult['answers'][0]['percent'],
              ),
              SurveyAnswerEntity(
                answer: surveyResult['answers'][1]['answer'],
                isCurrentAnswer: surveyResult['answers'][1]
                    ['isCurrentAccountAnswer'],
                percent: surveyResult['answers'][1]['percent'],
              )
            ]));
  });

  test(
      'Should return UnexpectedError if HttpClient returns 200 with invalid data',
      () async {
    mockHttpData(ApiFactory.makeInvalidJson());

    final future = sut.loadBySurvey(surveyId: surveyId);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Quando ocorrer um erro inesperado pelo HttpClient returns 404',
      () async {
    mockHttpError(HttpError.notFound);

    final future = sut.loadBySurvey(surveyId: surveyId);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Quando ocorrer um erro inesperado pelo HttpClient returns 500',
      () async {
    mockHttpError(HttpError.serverError);

    final future = sut.loadBySurvey(surveyId: surveyId);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Quando ocorrer um erro AccessDeniedError pelo HttpClient returns 403',
      () async {
    mockHttpError(HttpError.forbidden);

    final future = sut.loadBySurvey(surveyId: surveyId);

    expect(future, throwsA(DomainError.acessDenied));
  });
}
