import 'package:curso_tdd/data/usecases/usecase.dart';
import 'package:curso_tdd/domain/usecases/usecases.dart';
import 'package:curso_tdd/main/factories/http/http.dart';
import 'package:curso_tdd/main/factories/http/http_client_factory.dart';

IAuthentication makeRemoteAuthentication() {
  return RemoteAuthentication(
    httpClient: makeHttpAdapter(),
    url: makeApiUrl('login'),
  );
}
