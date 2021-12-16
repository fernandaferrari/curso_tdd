import 'dart:math';

import 'package:curso_tdd/presentation/presenter/dependencies/validation.dart';
import 'package:curso_tdd/validation/dependencies/field_validation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class ValidationComposite implements IValidation {
  final List<FieldValidation> validations;

  ValidationComposite(this.validations);

  @override
  String? validate({required String? field, required String? value}) {
    return null;
  }
}

class FieldValidationMock extends Mock implements FieldValidation {}

void main() {
  late ValidationComposite sut;
  final validator1 = FieldValidationMock();
  final validator2 = FieldValidationMock();

  setUp(() {
    sut = ValidationComposite([validator1, validator2]);
  });
  test('Should return null if all validations return null or empty', () {
    when(() => validator1.field).thenReturn('any_field');
    when(() => validator1.validate('any_value')).thenReturn(null);
    when(() => validator2.field).thenReturn('any_field');
    when(() => validator1.validate('any_value')).thenReturn('');

    final error = sut.validate(field: 'any_field', value: 'any_value');

    expect(error, null);
  });
}
