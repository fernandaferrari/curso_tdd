import 'package:curso_tdd/domain/entities/account_entity.dart';
import 'package:curso_tdd/domain/helpers/helpers.dart';
import 'package:curso_tdd/domain/usecases/usecases.dart';
import 'package:curso_tdd/presentation/presenter/dependencies/dependencies.dart';
import 'package:curso_tdd/presentation/presenter/presenter.dart';
import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class ValidationSpy extends Mock implements IValidation {}

class AuthenticationSpy extends Mock implements IAuthentication {}

class SaveCurrentAccountSpy extends Mock implements ISaveCurrentAccount {}

void main() {
  GetxLoginPresenter sut;
  AuthenticationSpy authentication;
  ValidationSpy validation;
  SaveCurrentAccountSpy saveCurrentAccount;
  String email;
  String password;
  String token;

  PostExpectation mockValidationCall(String field) => when(validation.validate(
      field: field == null ? anyNamed('field') : field,
      value: anyNamed('value')));

  void mockValidation({String field, String value}) {
    mockValidationCall(field).thenReturn(value);
  }

  PostExpectation mockAuthenticationCall() => when(authentication.auth(any));

  void mockAuthentication() {
    mockAuthenticationCall().thenAnswer((_) async => AccountEntity(token));
  }

  void mockAuthenticationError(DomainError error) {
    mockAuthenticationCall().thenThrow(error);
  }

  setUp(() {
    validation = ValidationSpy();
    authentication = AuthenticationSpy();
    saveCurrentAccount = SaveCurrentAccountSpy();
    sut = GetxLoginPresenter(
        validation: validation,
        authentication: authentication,
        saveCurrentAccount: saveCurrentAccount);
    email = faker.internet.email();
    password = faker.internet.password();
    token = faker.guid.guid();
    mockValidation();
    mockAuthentication();
  });

  test('Should call Validation with correct email', () {
    sut.validateEmail(email);

    verify(validation.validate(field: 'email', value: email)).called(1);
  });

  test('Should emit email error if validation fails', () {
    mockValidation(value: 'error');

    sut.emailErrorStream
        .listen(expectAsync1((error) => expect(error, 'error')));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('Should emit null if validation succeeds', () {
    sut.emailErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('Should call Validation with correct password', () {
    sut.validatePassword(password);

    verify(validation.validate(field: 'password', value: password)).called(1);
  });

  test('Should emit password error if validation fails', () {
    mockValidation(value: 'error');

    sut.passwordErrorStream
        .listen(expectAsync1((error) => expect(error, 'error')));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test('Should emit password error if validation fails', () {
    mockValidation(field: 'email', value: 'error');

    sut.emailErrorStream
        .listen(expectAsync1((error) => expect(error, 'error')));
    sut.passwordErrorStream
        .listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateEmail(email);
    sut.validatePassword(password);
  });

  test('Should emit password error if validation fails', () async {
    sut.emailErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.passwordErrorStream
        .listen(expectAsync1((error) => expect(error, null)));
    expectLater(sut.isFormValidStream, emitsInOrder([false, true]));

    sut.validateEmail(email);
    await Future.delayed(Duration.zero);
    sut.validatePassword(password);
  });

  test('Should call Authentication with correct values', () async {
    sut.validateEmail(email);
    sut.validatePassword(password);

    await sut.auth();

    verify(authentication
            .auth(AuthenticationParams(email: email, secret: password)))
        .called(1);
  });

  test('Should call SaveCurrentAccount with correct value', () async {
    sut.validateEmail(email);
    sut.validatePassword(password);

    await sut.auth();

    verify(saveCurrentAccount.save(AccountEntity(token))).called(1);
  });

  test('Should emit correct events on InvalidCredentialsError', () async {
    mockAuthenticationError(DomainError.invalidCredentials);
    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoadStream, emitsInOrder([true, false]));
    sut.mainErrorStream.listen(
        expectAsync1((error) => expect(error, 'Credenciais inválidas.')));

    await sut.auth();
  });

  test('Should emit correct events on UnexpectedError', () async {
    mockAuthenticationError(DomainError.unexpected);
    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoadStream, emitsInOrder([true, false]));
    sut.mainErrorStream.listen(expectAsync1((error) =>
        expect(error, 'Algo errado aconteceu. Tente novamente em breve.')));

    await sut.auth();
  });
}