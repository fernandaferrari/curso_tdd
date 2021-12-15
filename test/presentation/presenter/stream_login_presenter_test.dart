import 'package:curso_tdd/domain/usecases/authentication.dart';
import 'package:curso_tdd/presentation/presenter/dependencies/dependencies.dart';
import 'package:curso_tdd/presentation/presenter/presenter.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class ValidationMock extends Mock implements IValidation {}

class AuthenticationMock extends Mock implements IAuthentication {}

void main() {
  ValidationMock? validation;
  AuthenticationMock? authentication;
  StreamLoginPresenter? sut;
  late String email;
  late String password;

  When mockValidationCall(String field) => when(() => validation!.validate(
      field: field.isEmpty ? any(named: "field") : field,
      value: any(named: "value")));

  void mockValidation({String? field, String? value}) {
    mockValidationCall(field ?? '').thenReturn(value ?? '');
  }

  setUp(() {
    validation = ValidationMock();
    authentication = AuthenticationMock();
    sut = StreamLoginPresenter(
        validation: validation!, authentication: authentication!);
    email = faker.internet.email();
    password = faker.internet.password();
    mockValidation();
  });

  test('Validação email quando o email for correto', () {
    sut!.validateEmail(email);

    verify(() => validation!.validate(field: 'email', value: email)).called(1);
  });

  test('Should emit email error if validation fails', () {
    mockValidation(field: 'email', value: 'error');

    sut!.emailErrorStream
        .listen(expectAsync1((error) => expect(error, 'error')));
    sut!.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut!.validateEmail(email);
    sut!.validateEmail(email);
  });

  test('Should emit email null if validation succeeds', () {
    sut!.emailErrorStream.listen(expectAsync1((error) => expect(error, '')));
    sut!.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut!.validateEmail(email);
    sut!.validateEmail(email);
  });

  test('Validação password quando a senha for correto', () {
    sut!.validatePassword(password);

    verify(() => validation!.validate(field: 'password', value: password))
        .called(1);
  });

  test('Should emit password error if validation fails', () {
    mockValidation(value: 'error');

    sut!.passwordErrorStream
        .listen(expectAsync1((error) => expect(error, 'error')));
    sut!.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut!.validatePassword(password);
    sut!.validatePassword(password);
  });

  test('Should emit password null if validation succeeds', () {
    sut!.passwordErrorStream.listen(expectAsync1((error) => expect(error, '')));
    sut!.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut!.validatePassword(password);
    sut!.validatePassword(password);
  });

  test('Should emit msg error quando um dos campos não está preenchido', () {
    mockValidation(field: 'email', value: 'error');

    sut!.emailErrorStream
        .listen(expectAsync1((error) => expect(error, 'error')));
    sut!.passwordErrorStream.listen(expectAsync1((error) => expect(error, '')));
    sut!.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut!.validateEmail(email);
    sut!.validatePassword(password);
  });

  test('Should emit password error if validation fails', () async {
    sut!.emailErrorStream.listen(expectAsync1((error) => expect(error, '')));
    sut!.passwordErrorStream.listen(expectAsync1((error) => expect(error, '')));
    expectLater(sut!.isFormValidStream, emitsInOrder([false, true]));

    sut!.validateEmail(email);
    await Future.delayed(Duration.zero);
    sut!.validatePassword(password);
  });

  test('Should emit password error if validation fails', () async {
    sut!.validateEmail(email);
    sut!.validatePassword(password);

    await sut!.auth();

    verify(() => authentication!
        .auth(AuthenticationParams(email: email, secret: password))).called(1);
  });
}
