import 'package:curso_tdd/validation/dependencies/field_validation.dart';
import 'package:curso_tdd/validation/validators/validators.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class FieldValidationMock extends Mock implements FieldValidation {}

void main() {
  ValidationComposite sut;
  FieldValidationMock validator1;
  FieldValidationMock validator2;

  void mockValidator1(String error) {
    when(validator1.validate('any_value')).thenReturn(error);
  }

  void mockValidator2(String error) {
    when(validator2.validate('any_value')).thenReturn(error);
  }

  setUp(() {
    validator1 = FieldValidationMock();
    validator2 = FieldValidationMock();
    when(validator1.field).thenReturn('other_field');
    mockValidator1(null);
    when(validator2.field).thenReturn('any_field');
    mockValidator2(null);

    sut = ValidationComposite([validator1, validator2]);
  });
  test('Should return null if all validations return null or empty', () {
    mockValidator2('');
    final error = sut.validate(field: 'any_field', value: 'any_value');
    expect(error, null);
  });

  test(
      'teste para que retorne o primeiro erro encontrado dentre as validações do field correto',
      () {
    mockValidator1('error_1');
    mockValidator2('error_2');

    final error = sut.validate(field: 'any_field', value: 'any_value');
    expect(error, 'error_2');
  });
}
