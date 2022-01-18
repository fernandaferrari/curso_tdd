import 'package:curso_tdd/data/http/http.dart';
import 'package:curso_tdd/data/model/model.dart';
import 'package:curso_tdd/domain/entities/entities.dart';
import 'package:curso_tdd/domain/helpers/helpers.dart';
import 'package:curso_tdd/domain/usecases/usecases.dart';
import 'package:meta/meta.dart';

class RemoteAddAccount implements AddAccount {
  final IHttpClient<Map> httpClient;
  final String url;

  RemoteAddAccount({@required this.httpClient, @required this.url});

  Future<AccountEntity> add(AddAccountParams params) async {
    final body = RemoteAddAccountParams.fromDomain(params).toJson();
    try {
      final httpResponse =
          await httpClient.request(url: url, method: 'post', body: body);
      return RemoteAccountModel.fromJson(httpResponse).toEntity();
    } on HttpError catch (error) {
      throw error == HttpError.forbidden
          ? DomainError.emailInUse
          : DomainError.unexpected;
    }
  }
}

class RemoteAddAccountParams {
  final String name;
  final String email;
  final String password;
  final String passwordConfirmation;

  RemoteAddAccountParams({
    @required this.email,
    @required this.password,
    @required this.name,
    @required this.passwordConfirmation,
  });

  factory RemoteAddAccountParams.fromDomain(AddAccountParams params) =>
      RemoteAddAccountParams(
          email: params.email,
          password: params.password,
          passwordConfirmation: params.passwordConfirmation,
          name: params.name);

  Map toJson() => {
        "email": email,
        "password": password,
        "name": name,
        "passwordConfirmation": passwordConfirmation
      };
}
