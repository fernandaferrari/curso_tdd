import 'package:curso_tdd/main/factories/pages/signup/signup.dart';
import 'package:curso_tdd/validation/validators/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('testando o retorno correto das validações signUp...', () {
    final validations = makeSignUpValidations();

    expect(validations, [
      RequiredFieldValidation('name'),
      MinLengthValidation(field: 'name', size: 3),
      RequiredFieldValidation('email'),
      EmailValidator('email'),
      RequiredFieldValidation('password'),
      MinLengthValidation(field: 'password', size: 3),
      RequiredFieldValidation('confirm_password'),
      CompareFieldValidation(
          field: 'confirm_password', fieldToCompare: 'password')
    ]);
  });
}
