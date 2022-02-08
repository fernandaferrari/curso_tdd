import 'package:curso_tdd/data/http/http.dart';
import 'package:mocktail/mocktail.dart';

class HttpClientSpy extends Mock implements IHttpClient {
  When mockHttpResponseCall() => when(() => request(
      url: any(named: 'url'),
      method: any(named: 'method'),
      body: any(named: 'body'),
      headers: any(named: 'headers')));

  void mockHttpResponse(dynamic data) {
    mockHttpResponseCall().thenAnswer((_) async => data);
  }

  void mockHttpResponseError(HttpError error) =>
      mockHttpResponseCall().thenThrow(error);
}
