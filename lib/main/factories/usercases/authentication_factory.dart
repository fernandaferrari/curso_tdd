import 'package:curso_tdd/data/usercases/authentication/authentication.dart';
import 'package:curso_tdd/domain/usecases/usecases.dart';
import 'package:curso_tdd/main/factories/http/http.dart';

IAuthentication makeRemoteAuthentication() {
  return RemoteAuthentication(
    httpClient: makeHttpAdapter(),
    url: makeApiUrl('login'),
  );
}
