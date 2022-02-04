import 'package:curso_tdd/data/model/model.dart';
import 'package:curso_tdd/domain/entities/entities.dart';
import 'package:curso_tdd/domain/helpers/helpers.dart';
import 'package:curso_tdd/domain/usecases/save_survey_result.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:meta/meta.dart';

import 'package:curso_tdd/data/http/http.dart';

class HttpClientSpy extends Mock implements IHttpClient {}

class RemoteSaveSurveyResult implements SaveSurveyResult {
  final IHttpClient httpClient;
  final String url;

  RemoteSaveSurveyResult({
    @required this.httpClient,
    @required this.url,
  });

  Future<SurveyResultEntity> save({String answer}) async {
    try {
      final json = await httpClient
          .request(url: url, method: 'put', body: {'answer': answer});
      return RemoteSurveyResultModel.fromJson(json).toEntity();
    } on HttpError catch (error) {
      throw error == HttpError.forbidden
          ? DomainError.acessDenied
          : DomainError.unexpected;
    }
  }
}

void main() {
  RemoteSaveSurveyResult sut;
  HttpClientSpy httpClient;
  String url;
  String answer;

  Map surveyResult;

  Map mockValidData() => {
        'surveyId': faker.guid.guid(),
        'question': faker.randomGenerator.string(50),
        'answers': [
          {
            'image': faker.internet.httpUrl(),
            'answer': faker.randomGenerator.string(20),
            'percent': faker.randomGenerator.integer(100),
            'count': faker.randomGenerator.integer(1000),
            'isCurrentAccountAnswer': faker.randomGenerator.boolean()
          },
          {
            'answer': faker.randomGenerator.string(20),
            'percent': faker.randomGenerator.integer(100),
            'count': faker.randomGenerator.integer(1000),
            'isCurrentAccountAnswer': faker.randomGenerator.boolean()
          }
        ],
        'date': faker.date.dateTime().toIso8601String(),
      };

  PostExpectation mockRequestCall() => when(httpClient.request(
      url: anyNamed("url"),
      method: anyNamed("method"),
      body: anyNamed("body"),
      headers: anyNamed("headers")));
  void mockHttpData(dynamic data) {
    surveyResult = data;
    mockRequestCall().thenAnswer((_) async => data);
  }

  void mockHttpError(HttpError error) => mockRequestCall().thenThrow(error);

  setUp(() {
    answer = faker.lorem.sentence();
    url = faker.internet.httpUrl();
    httpClient = HttpClientSpy();
    sut = RemoteSaveSurveyResult(url: url, httpClient: httpClient);
    mockHttpData(mockValidData());
  });

  test('Should call HttClient with correct values', () async {
    await sut.save(answer: answer);

    verify(
        httpClient.request(url: url, method: 'put', body: {'answer': answer}));
  });

  test('Should return surveysResult on 200', () async {
    final result = await sut.save(answer: answer);

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
    mockHttpData({'invalid_key': 'invalid_value'});

    final future = sut.save(answer: answer);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Quando ocorrer um erro inesperado pelo HttpClient returns 404',
      () async {
    mockHttpError(HttpError.notFound);

    final future = sut.save(answer: answer);
    expect(future, throwsA(DomainError.unexpected));
  });

  test('Quando ocorrer um erro inesperado pelo HttpClient returns 500',
      () async {
    mockHttpError(HttpError.serverError);

    final future = sut.save(answer: answer);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Quando ocorrer um erro AccessDeniedError pelo HttpClient returns 403',
      () async {
    mockHttpError(HttpError.forbidden);

    final future = sut.save(answer: answer);

    expect(future, throwsA(DomainError.acessDenied));
  });
}
