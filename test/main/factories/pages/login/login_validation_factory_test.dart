import 'package:curso_tdd/main/factories/factories.dart';
import 'package:curso_tdd/validation/validators/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('testando o retorno correto das validações login...', () {
    final validations = makeLoginValidations();

    expect(validations, [
      RequiredFieldValidation('email'),
      EmailValidator('email'),
      RequiredFieldValidation('password')
    ]);
  });
}
