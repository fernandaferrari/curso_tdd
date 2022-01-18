import 'package:curso_tdd/data/model/model.dart';
import 'package:curso_tdd/domain/entities/entities.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';

import 'package:curso_tdd/data/http/http.dart';

class RemoteLoadSurveys {
  final String url;
  final IHttpClient<List<Map>> httpClient;

  RemoteLoadSurveys({
    @required this.url,
    @required this.httpClient,
  });

  Future<List<SurveyEntity>> load() async {
    final httpResponse = await httpClient.request(url: url, method: 'get');
    return httpResponse
        .map((json) => RemoteSurveyModel.fromJson(json).toEntity())
        .toList();
  }
}

class HttpClientSpy extends Mock implements IHttpClient<List<Map>> {}

void main() {
  RemoteLoadSurveys sut;
  HttpClientSpy httpClient;
  String url;
  List<Map> list;

  List<Map> mockValidData() => [
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

  PostExpectation mockRequest() => when(
      httpClient.request(url: anyNamed('url'), method: anyNamed('method')));

  void mockHttpData(List<Map> data) {
    list = data;
    mockRequest().thenAnswer((_) async => data);
  }

  setUp(() {
    url = faker.internet.httpUrl();
    httpClient = HttpClientSpy();
    sut = RemoteLoadSurveys(url: url, httpClient: httpClient);
    mockHttpData(mockValidData());
  });

  test('Should call HttClient with correct values', () async {
    sut.load();

    verify(httpClient.request(url: url, method: 'get'));
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
}
