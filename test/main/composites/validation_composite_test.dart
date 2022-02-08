import 'package:curso_tdd/main/composites/composites.dart';
import 'package:curso_tdd/presentation/presenter/dependencies/validation.dart';
import 'package:curso_tdd/validation/dependencies/field_validation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class FieldValidationMock extends Mock implements FieldValidation {}

void main() {
  late ValidationComposite sut;
  late FieldValidationMock validator1;
  late FieldValidationMock validator2;

  void mockValidator1(ValidationError? error) {
    when(() => validator1.validate(any())).thenReturn(error);
  }

  void mockValidator2(ValidationError? error) {
    when(() => validator2.validate(any())).thenReturn(error);
  }

  setUp(() {
    validator1 = FieldValidationMock();
    validator2 = FieldValidationMock();
    when(() => validator1.field).thenReturn('other_field');
    mockValidator1(null);
    when(() => validator2.field).thenReturn('any_field');
    mockValidator2(null);

    sut = ValidationComposite([validator1, validator2]);
  });
  test('Should return null if all validations return null or empty', () {
    final error = sut.validate(field: 'any_field', input: {});
    expect(error, null);
  });

  test(
      'teste para que retorne o primeiro erro encontrado dentre as validações do field correto',
      () {
    mockValidator1(ValidationError.invalidField);
    mockValidator2(ValidationError.requiredField);

    final error =
        sut.validate(field: 'any_field', input: {'any_field': 'any_value'});
    expect(error, ValidationError.requiredField);
  });
}
