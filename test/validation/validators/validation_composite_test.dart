import 'dart:ffi';
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
    String? error;
    for (final validation in validations.where((v) => v.field == field)) {
      error = validation.validate(value!);
      if (error?.isNotEmpty == true) {
        return error;
      }
    }
    return error!.isEmpty ? null : error;
  }
}

class FieldValidationMock extends Mock implements FieldValidation {}

void main() {
  late ValidationComposite sut;
  late FieldValidationMock validator1;
  late FieldValidationMock validator2;

  void mockValidator1(String? error) {
    when(() => validator1.validate('any_value')).thenReturn(error);
  }

  void mockValidator2(String? error) {
    when(() => validator2.validate('any_value')).thenReturn(error);
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
    mockValidator2('');
    final error = sut.validate(field: 'any_field', value: 'any_value');
    expect(error, null);
  });

  test('teste para que retorne o primeiro erro encontrado dentre as validações',
      () {
    mockValidator1('error_1');
    mockValidator2('error_2');

    final error = sut.validate(field: 'any_field', value: 'any_value');
    expect(error, 'error_2');
  });
}
