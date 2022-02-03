import 'package:curso_tdd/main/decorators/decorators.dart';
import 'package:curso_tdd/main/factories/factories.dart';

import '../../../data/http/http.dart';

IHttpClient makeAuthorizeHttpClientDecorator() => AuthorizeHttpClientDecorator(
    decoratee: makeHttpAdapter(),
    fetchSecureCacheStorage: makeSecureStorageAdapter(),
    deleteSecureCacheStorage: makeSecureStorageAdapter());
