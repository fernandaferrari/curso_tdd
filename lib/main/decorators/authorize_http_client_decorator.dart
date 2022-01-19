import 'package:meta/meta.dart';

import 'package:curso_tdd/data/cache/cache.dart';
import 'package:curso_tdd/data/http/http.dart';

class AuthorizeHttpClientDecorator implements IHttpClient {
  final FetchSecureCacheStorage fetchSecureCacheStorage;
  final IHttpClient decoratee;

  AuthorizeHttpClientDecorator(
      {@required this.fetchSecureCacheStorage, @required this.decoratee});

  Future<dynamic> request(
      {@required String url,
      @required String method,
      Map body,
      Map headers}) async {
    try {
      final token = await fetchSecureCacheStorage.fetchSecure('token');
      final authorizedHeaders = headers ?? {}
        ..addAll({'x-access-token': token});
      return await decoratee.request(
          url: url, method: method, body: body, headers: authorizedHeaders);
    } on HttpError {
      rethrow;
    } catch (error) {
      throw HttpError.forbidden;
    }
  }
}
