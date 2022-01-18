import 'package:curso_tdd/data/usercases/add_account/add_account.dart';
import 'package:curso_tdd/domain/usecases/add_account.dart';
import 'package:curso_tdd/main/factories/http/http.dart';

AddAccount makeRemoteAddAccount() {
  return RemoteAddAccount(
      httpClient: makeHttpAdapter(), url: makeApiUrl('signup'));
}
