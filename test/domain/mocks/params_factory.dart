import 'package:curso_tdd/domain/usecases/usecases.dart';
import 'package:faker/faker.dart';

class ParamsFactory {
  static AddAccountParams makeAddAccount() => AddAccountParams(
        email: faker.internet.email(),
        password: faker.internet.password(),
        name: faker.person.name(),
        passwordConfirmation: faker.internet.password(),
      );

  static AuthenticationParams makeAuthentication() => AuthenticationParams(
      email: faker.internet.email(), secret: faker.internet.password());
}
