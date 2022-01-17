import 'package:curso_tdd/presentation/presenter/dependencies/validation.dart';
import 'package:curso_tdd/validation/validators/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  CompareFieldValidation sut;

  setUp(() {
    sut =
        CompareFieldValidation(field: 'any_field', valueToCompare: 'any_value');
  });

  test('Should return error if value is not equal', () {
    expect(sut.validate("wrong_value"), ValidationError.invalidField);
  });

  test('Should return null if value is equal', () {
    expect(sut.validate('any_value'), null);
  });
}
