import 'package:curso_tdd/domain/entities/entities.dart';
import 'package:curso_tdd/domain/helpers/helpers.dart';
import 'package:curso_tdd/domain/usecases/usecases.dart';
import 'package:curso_tdd/presentation/presenter/dependencies/dependencies.dart';
import 'package:curso_tdd/presentation/presenter/presenter.dart';
import 'package:curso_tdd/ui/helpers/errors/ui_error.dart';
import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class ValidationSpy extends Mock implements IValidation {}

class AddAccountSpy extends Mock implements AddAccount {}

class SaveCurrentAccountSpy extends Mock implements ISaveCurrentAccount {}

void main() {
  GetxSignUpPresenter sut;
  ValidationSpy validation;
  AddAccountSpy addAccount;
  SaveCurrentAccountSpy saveCurrentAccount;
  String name;
  String email;
  String password;
  String confirmPassword;
  String token;

  PostExpectation mockValidationCall(String field) => when(validation.validate(
      field: field == null ? anyNamed('field') : field,
      input: anyNamed('input')));

  void mockValidation({String field, ValidationError value}) {
    mockValidationCall(field).thenReturn(value);
  }

  PostExpectation mockAddAccountCall() => when(addAccount.add(any));

  void mockAddAccount() {
    mockAddAccountCall().thenAnswer((_) async => AccountEntity(token: token));
  }

  void mockAddAccountError(DomainError error) {
    mockAddAccountCall().thenThrow(error);
  }

  PostExpectation mockSaveCurrentAccountCall() =>
      when(saveCurrentAccount.save(any));

  void mockSaveCurrentAccountError() {
    mockSaveCurrentAccountCall().thenThrow(DomainError.unexpected);
  }

  setUp(() {
    addAccount = AddAccountSpy();
    validation = ValidationSpy();
    saveCurrentAccount = SaveCurrentAccountSpy();
    sut = GetxSignUpPresenter(
        validation: validation,
        addAccount: addAccount,
        saveCurrentAccount: saveCurrentAccount);
    email = faker.internet.email();
    name = faker.person.name();
    password = faker.internet.password();
    confirmPassword = faker.internet.password();
    token = faker.guid.guid();
    mockValidation();
    mockAddAccount();
  });

  test('Should call Validation with correct email', () {
    final formData = {
      'email': email,
      'password': null,
      'name': null,
      'confirm_password': null
    };
    sut.validateEmail(email);

    verify(validation.validate(field: 'email', input: formData)).called(1);
  });

  test('Should emit invalidfieldError if email is empyt', () {
    mockValidation(value: ValidationError.invalidField);

    sut.emailErrorStream
        .listen(expectAsync1((error) => expect(error, UIError.invalidField)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('Should emit requiredfieldError if email is empyt', () {
    mockValidation(value: ValidationError.requiredField);

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

  test('Should call Validation with correct name', () {
    final formData = {
      'email': null,
      'password': null,
      'name': name,
      'confirm_password': null
    };
    sut.validateName(name);

    verify(validation.validate(field: 'name', input: formData)).called(1);
  });

  test('Should emit invalidfieldError if name is empyt', () {
    mockValidation(value: ValidationError.invalidField);

    sut.nameErrorStream
        .listen(expectAsync1((error) => expect(error, UIError.invalidField)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateName(name);
    sut.validateName(name);
  });

  test('Should emit requiredfieldError if name is empyt', () {
    mockValidation(value: ValidationError.requiredField);

    sut.nameErrorStream
        .listen(expectAsync1((error) => expect(error, UIError.requiredField)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateName(name);
    sut.validateName(name);
  });

  test('Should emit null if validation succeeds name', () {
    sut.nameErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateName(name);
    sut.validateName(name);
  });

  test('Should call Validation with correct password', () {
    final formData = {
      'email': null,
      'password': password,
      'name': null,
      'confirm_password': null
    };
    sut.validatePassword(password);

    verify(validation.validate(field: 'password', input: formData)).called(1);
  });

  test('Should emit invalidfieldError if password is empyt', () {
    mockValidation(value: ValidationError.invalidField);

    sut.passwordErrorStream
        .listen(expectAsync1((error) => expect(error, UIError.invalidField)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validatePassword(password);
  });

  test('Should emit requiredfieldError if password is empyt', () {
    mockValidation(value: ValidationError.requiredField);

    sut.passwordErrorStream
        .listen(expectAsync1((error) => expect(error, UIError.requiredField)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));
    sut.validatePassword(password);
  });

  test('Should emit null if validation succeeds password', () {
    sut.passwordErrorStream
        .listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validatePassword(password);
  });

  test('Should call Validation with correct confirm password', () {
    final formData = {
      'email': null,
      'password': null,
      'name': null,
      'confirm_password': confirmPassword
    };
    sut.validateConfirmPassword(confirmPassword);

    verify(validation.validate(field: 'confirm_password', input: formData))
        .called(1);
  });

  test('Should emit invalidfieldError if confirm password is empyt', () {
    mockValidation(value: ValidationError.invalidField);

    sut.confirmPasswordErrorStream
        .listen(expectAsync1((error) => expect(error, UIError.invalidField)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateConfirmPassword(confirmPassword);
  });

  test('Should emit requiredfieldError if confirm password is empyt', () {
    mockValidation(value: ValidationError.requiredField);

    sut.confirmPasswordErrorStream
        .listen(expectAsync1((error) => expect(error, UIError.requiredField)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));
    sut.validateConfirmPassword(confirmPassword);
  });

  test('Should emit null if validation succeeds confirm password', () {
    sut.confirmPasswordErrorStream
        .listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateConfirmPassword(confirmPassword);
  });

  test('Should enable form button if all fields are valid', () async {
    expectLater(sut.isFormValidStream, emitsInOrder([false, true]));

    sut.validateName(name);
    await Future.delayed(Duration.zero);
    sut.validateEmail(email);
    await Future.delayed(Duration.zero);
    sut.validatePassword(password);
    await Future.delayed(Duration.zero);
    sut.validateConfirmPassword(confirmPassword);
    await Future.delayed(Duration.zero);
  });

  test('Should call addAccount with correct values', () async {
    sut.validateName(name);
    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validateConfirmPassword(confirmPassword);

    await sut.signup();

    verify(addAccount.add(AddAccountParams(
            email: email,
            password: password,
            name: name,
            passwordConfirmation: confirmPassword)))
        .called(1);
  });

  test('Should emit correct events on EmailInUserError', () async {
    mockAddAccountError(DomainError.emailInUse);
    sut.validateName(name);
    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validateConfirmPassword(confirmPassword);

    expectLater(sut.mainErrorStream, emitsInOrder([null, UIError.emailInUse]));
    expectLater(sut.isLoadStream, emitsInOrder([true, false]));

    await sut.signup();
  });

  test('Should call SaveCurrentAccount with correct value', () async {
    sut.validateEmail(email);
    sut.validatePassword(password);

    await sut.signup();

    verify(saveCurrentAccount.save(AccountEntity(token: token))).called(1);
  });

  test('Should emit UnexpectedError if SavecurrenteAccount fails', () async {
    mockSaveCurrentAccountError();
    sut.validateName(name);
    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validateConfirmPassword(confirmPassword);

    expectLater(sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));
    expectLater(sut.isLoadStream, emitsInOrder([true, false]));

    await sut.signup();
  });

  test('Should emit correct events on InvalidCredentialsError', () async {
    mockAddAccountError(DomainError.invalidCredentials);
    sut.validateName(name);
    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validateConfirmPassword(confirmPassword);

    expectLater(
        sut.mainErrorStream, emitsInOrder([null, UIError.invalidCredentials]));

    expectLater(sut.isLoadStream, emitsInOrder([true, false]));

    await sut.signup();
  });

  test('Should emit correct events on UnexpectedError', () async {
    mockAddAccountError(DomainError.unexpected);
    sut.validateName(name);
    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validateConfirmPassword(confirmPassword);

    expectLater(sut.isLoadStream, emitsInOrder([true, false]));
    expectLater(sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));

    await sut.signup();
  });

  test('Should emit correct events on AddAccount success', () async {
    sut.validateName(name);
    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validateConfirmPassword(confirmPassword);

    expectLater(sut.mainErrorStream, emits(null));
    expectLater(sut.isLoadStream, emits(true));

    await sut.signup();
  });

  test('Should change page on success', () async {
    sut.validateName(name);
    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validateConfirmPassword(confirmPassword);

    sut.navigateToStream
        .listen(expectAsync1((page) => expect(page, '/surveys')));

    await sut.signup();
  });

  test('Should go to SignUpPage on link click', () {
    sut.navigateToStream.listen(expectAsync1((page) => expect(page, '/login')));
    sut.goToLogin();
  });
}
