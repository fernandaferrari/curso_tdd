import '../entities/account_entity.dart';

abstract class IAuthentication {
  Future<AccountEntity> auth(AuthenticationParams params);
}

class AuthenticationParams {
  final String email;
  final String secret;

  AuthenticationParams({required this.email, required this.secret});

  toJson() => {"email": email, "password": secret};
}
