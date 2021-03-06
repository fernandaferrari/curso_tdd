import 'package:curso_tdd/data/usercases/load_surveys/load_surveys.dart';
import 'package:curso_tdd/domain/entities/entities.dart';
import 'package:curso_tdd/domain/helpers/helpers.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:curso_tdd/data/http/http.dart';

import '../../../infra/mocks/mocks.dart';

class HttpClientSpy extends Mock implements IHttpClient {}

void main() {
  late RemoteLoadSurveys sut;
  late HttpClientSpy httpClient;
  late String url;
  late List<dynamic> list;

  When mockRequest() => when(() =>
      httpClient.request(url: any(named: 'url'), method: any(named: 'method')));

  void mockHttpData(List<dynamic> data) {
    list = data;
    mockRequest().thenAnswer((_) async => data);
  }

  void mockHttpError(HttpError error) {
    mockRequest().thenThrow(error);
  }

  setUp(() {
    url = faker.internet.httpUrl();
    httpClient = HttpClientSpy();
    sut = RemoteLoadSurveys(url: url, httpClient: httpClient);
    mockHttpData(ApiFactory.makeSurveyList());
  });

  test('Should call HttClient with correct values', () async {
    sut.load();

    verify(() => httpClient.request(url: url, method: 'get'));
  });

  test('Should return surveys on 200', () async {
    final surveys = await sut.load();

    expect(surveys, [
      SurveyEntity(
          id: list[0]['id'],
          question: list[0]['question'],
          didAnswer: list[0]['didAnswer'],
          dateTime: DateTime.parse(list[0]['date'])),
      SurveyEntity(
          id: list[1]['id'],
          question: list[1]['question'],
          didAnswer: list[1]['didAnswer'],
          dateTime: DateTime.parse(list[1]['date']))
    ]);
  });

  test(
      'Should return UnexpectedError if HttpClient returns 200 with invalid data',
      () async {
    mockHttpData(ApiFactory.makeInvalidList());

    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Quando ocorrer um erro inesperado pelo HttpClient returns 404',
      () async {
    mockHttpError(HttpError.notFound);

    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Quando ocorrer um erro inesperado pelo HttpClient returns 500',
      () async {
    mockHttpError(HttpError.serverError);

    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Quando ocorrer um erro AccessDeniedError pelo HttpClient returns 403',
      () async {
    mockHttpError(HttpError.forbidden);

    final future = sut.load();

    expect(future, throwsA(DomainError.acessDenied));
  });
}
