import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';

import 'package:curso_tdd/data/http/http.dart';

class RemoteLoadSurveys {
  final String url;
  final IHttpClient httpClient;

  RemoteLoadSurveys({
    @required this.url,
    @required this.httpClient,
  });

  Future<void> load() async {
    return await httpClient.request(url: url, method: 'get');
  }
}

class HttpClientSpy extends Mock implements IHttpClient {}

void main() {
  RemoteLoadSurveys sut;
  HttpClientSpy httpClient;
  String url;

  setUp(() {
    url = faker.internet.httpUrl();
    httpClient = HttpClientSpy();
    sut = RemoteLoadSurveys(url: url, httpClient: httpClient);
  });

  test('Should call HttClient with correct values', () async {
    sut.load();

    verify(httpClient.request(url: url, method: 'get'));
  });
}
