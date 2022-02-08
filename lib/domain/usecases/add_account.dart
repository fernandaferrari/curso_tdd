import 'package:equatable/equatable.dart';
import '../entities/account_entity.dart';

abstract class AddAccount {
  Future<AccountEntity> add(AddAccountParams params);
}

class AddAccountParams extends Equatable {
  final String name;
  final String email;
  final String password;
  final String passwordConfirmation;

  const AddAccountParams({
    required this.email,
    required this.password,
    required this.name,
    required this.passwordConfirmation,
  });

  toJson() => {
        "email": email,
        "password": password,
        "name": name,
        "passwordConfirmation": passwordConfirmation
      };

  @override
  List<Object> get props => [email, password, name, passwordConfirmation];
}
