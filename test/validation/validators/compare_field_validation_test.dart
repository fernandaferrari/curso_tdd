import 'package:curso_tdd/presentation/presenter/dependencies/validation.dart';
import 'package:curso_tdd/validation/validators/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  CompareFieldValidation sut;

  setUp(() {
    sut = CompareFieldValidation(
        field: 'any_field', fieldToCompare: 'other_field');
  });

  test('Should return error if value is not equal', () {
    final formData = {"any_field": "any_field", "other_field": "other_field"};
    expect(sut.validate(formData), ValidationError.invalidField);
  });

  test('Should return null if value is equal', () {
    final formData = {"any_field": "any_field", "other_field": "any_field"};
    expect(sut.validate(formData), null);
  });
}
