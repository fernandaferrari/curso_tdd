import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:meta/meta.dart';

import 'package:curso_tdd/data/http/http.dart';

class HttpClientSpy extends Mock implements IHttpClient {}

class RemoteSaveSurveyResult {
  final IHttpClient httpClient;
  final String url;

  RemoteSaveSurveyResult({
    @required this.httpClient,
    @required this.url,
  });

  Future<void> save({String answer}) async {
    await httpClient.request(url: url, method: 'put', body: {'answer': answer});
  }
}

void main() {
  RemoteSaveSurveyResult sut;
  HttpClientSpy httpClient;
  String url;
  String answer;

  setUp(() {
    answer = faker.lorem.sentence();
    url = faker.internet.httpUrl();
    httpClient = HttpClientSpy();
    sut = RemoteSaveSurveyResult(url: url, httpClient: httpClient);
  });

  test('Should call HttClient with correct values', () async {
    await sut.save(answer: answer);

    verify(
        httpClient.request(url: url, method: 'put', body: {'answer': answer}));
  });
}
