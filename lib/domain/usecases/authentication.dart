import 'package:equatable/equatable.dart';
import '../entities/account_entity.dart';
import 'package:meta/meta.dart';

abstract class IAuthentication {
  Future<AccountEntity> auth(AuthenticationParams params);
}

class AuthenticationParams extends Equatable {
  final String email;
  final String secret;

  const AuthenticationParams({@required this.email, @required this.secret});

  toJson() => {"email": email, "password": secret};

  @override
  List<Object> get props => [email, secret];
}
