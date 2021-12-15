import 'package:curso_tdd/presentation/presenter/dependencies/dependencies.dart';
import 'package:curso_tdd/presentation/presenter/presenter.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class ValidationMock extends Mock implements IValidation {}

void main() {
  ValidationMock? validation;
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
    sut = StreamLoginPresenter(validation: validation!);
    email = faker.internet.email();
    password = faker.internet.password();
    mockValidation();
  });

  test('Validação email quando o email for correto', () {
    sut!.validateEmail(email);

    verify(() => validation!.validate(field: 'email', value: email)).called(1);
  });

  test('Should emit email error if validation fails', () {
    mockValidation(value: 'error');

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

  test('Should emit email error if validation fails', () {
    mockValidation(value: 'error');

    sut!.passwordErrorStream
        .listen(expectAsync1((error) => expect(error, 'error')));
    sut!.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut!.validateEmail(password);
    sut!.validateEmail(password);
  });

  test('Should emit password null if validation succeeds', () {
    sut!.passwordErrorStream.listen(expectAsync1((error) => expect(error, '')));
    sut!.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut!.validateEmail(password);
    sut!.validateEmail(password);
  });
}
