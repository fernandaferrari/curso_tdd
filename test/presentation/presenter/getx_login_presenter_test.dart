import 'package:curso_tdd/domain/entities/account_entity.dart';
import 'package:curso_tdd/domain/helpers/helpers.dart';
import 'package:curso_tdd/domain/usecases/usecases.dart';
import 'package:curso_tdd/presentation/presenter/dependencies/dependencies.dart';
import 'package:curso_tdd/presentation/presenter/presenter.dart';
import 'package:curso_tdd/ui/helpers/errors/ui_error.dart';
import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../domain/mocks/mocks.dart';
import '../mocks/mocks.dart';

void main() {
  late GetxLoginPresenter sut;
  late AuthenticationSpy authentication;
  late ValidationSpy validation;
  late SaveCurrentAccountSpy saveCurrentAccount;
  late String email;
  late String password;
  late AccountEntity account;

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
    validation.mockValidation();
    account = EntityFactory.makeAccount();
    authentication.mockAuthentication(account);
  });

  setUpAll(() {
    registerFallbackValue(ParamsFactory.makeAuthentication());
    registerFallbackValue(EntityFactory.makeAccount());
  });

  test('Should call Validation with correct email', () {
    final formData = {'email': email, 'password': null};
    sut.validateEmail(email);

    verify(() => validation.validate(field: 'email', input: formData))
        .called(1);
  });

  test('Should emit invalidfieldError if email is empyt', () {
    validation.mockValidationError(value: ValidationError.invalidField);

    sut.emailErrorStream
        .listen(expectAsync1((error) => expect(error, UIError.invalidField)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('Should emit requiredfieldError if email is empyt', () {
    validation.mockValidationError(value: ValidationError.requiredField);

    sut.emailErrorStream
        .listen(expectAsync1((error) => expect(error, UIError.requiredField)));
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
    final formData = {'email': null, 'password': password};
    sut.validatePassword(password);

    verify(() => validation.validate(field: 'password', input: formData))
        .called(1);
  });

  test('Should emit password error if validation fails', () {
    validation.mockValidationError(value: ValidationError.requiredField);

    sut.passwordErrorStream
        .listen(expectAsync1((error) => expect(error, UIError.requiredField)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test('Should enable form button if all fields are valid', () async {
    expectLater(sut.isFormValidStream, emitsInOrder([false, true]));

    sut.validateEmail(email);
    await Future.delayed(Duration.zero);
    sut.validatePassword(password);
  });

  test('Should call Authentication with correct values', () async {
    sut.validateEmail(email);
    sut.validatePassword(password);

    await sut.auth();

    verify(() => authentication
        .auth(AuthenticationParams(email: email, secret: password))).called(1);
  });

  test('Should change page on success', () async {
    sut.validateEmail(email);
    sut.validatePassword(password);

    sut.navigateToStream
        .listen(expectAsync1((page) => expect(page, '/surveys')));

    await sut.auth();
  });

  test('Should call SaveCurrentAccount with correct value', () async {
    sut.validateEmail(email);
    sut.validatePassword(password);

    await sut.auth();

    verify(() => saveCurrentAccount.save(account)).called(1);
  });

  test('Should emit UnexpectedError if SavecurrenteAccount fails', () async {
    saveCurrentAccount.mockSaveError();
    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));

    expectLater(sut.isLoadStream, emitsInOrder([true, false]));

    await sut.auth();
  });

  test('Should emit correct events on InvalidCredentialsError', () async {
    authentication.mockAuthenticationError(DomainError.invalidCredentials);
    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(
        sut.mainErrorStream, emitsInOrder([null, UIError.invalidCredentials]));

    expectLater(sut.isLoadStream, emitsInOrder([true, false]));

    await sut.auth();
  });

  test('Should emit correct events on UnexpectedError', () async {
    authentication.mockAuthenticationError(DomainError.unexpected);
    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));
    expectLater(sut.isLoadStream, emitsInOrder([true, false]));

    await sut.auth();
  });

  test('Should go to SignUpPage on link click', () async {
    sut.navigateToStream
        .listen(expectAsync1((page) => expect(page, '/signup')));
    sut.goToSingUp();
  });
}
