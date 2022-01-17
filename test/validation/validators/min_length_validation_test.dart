import 'package:curso_tdd/presentation/presenter/dependencies/validation.dart';
import 'package:curso_tdd/validation/dependencies/field_validation.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meta/meta.dart';

class MinLengthValidation implements FieldValidation {
  final String field;
  final int size;
  MinLengthValidation({
    @required this.field,
    @required this.size,
  });

  @override
  ValidationError validate(String value) {
    return value != null && value.length >= size
        ? null
        : ValidationError.requiredField;
  }
}

void main() {
  MinLengthValidation sut;

  setUp(() {
    sut = MinLengthValidation(field: 'any_field', size: 5);
  });

  test('Should return error if value is empty', () {
    final error = sut.validate('');

    expect(error, ValidationError.requiredField);
  });

  test('Should return error if value is null', () {
    final error = sut.validate(null);

    expect(error, ValidationError.requiredField);
  });

  test('Should return error if value is less than min size', () {
    expect(sut.validate(faker.randomGenerator.string(4, min: 1)),
        ValidationError.requiredField);
  });

  test('Should return null if value is equal than min size', () {
    expect(sut.validate(faker.randomGenerator.string(5, min: 5)), null);
  });

  test('Should return null if value is bigger than min size', () {
    expect(sut.validate(faker.randomGenerator.string(10, min: 6)), null);
  });
}
