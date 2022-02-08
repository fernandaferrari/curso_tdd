import 'package:curso_tdd/presentation/presenter/dependencies/validation.dart';
import 'package:curso_tdd/validation/validators/validators.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late MinLengthValidation sut;

  setUp(() {
    sut = MinLengthValidation(field: 'any_field', size: 5);
  });

  test('Should return error if value is empty', () {
    final error = sut.validate({'any_field': ''});

    expect(error, ValidationError.invalidField);
  });

  test('Should return error if value is null', () {
    final error = sut.validate({'any_field': null});

    expect(error, ValidationError.invalidField);
  });

  test('Should return error if value is less than min size', () {
    expect(sut.validate({'any_field': faker.randomGenerator.string(4, min: 1)}),
        ValidationError.invalidField);
  });

  test('Should return null if value is equal than min size', () {
    expect(sut.validate({'any_field': faker.randomGenerator.string(5, min: 5)}),
        null);
  });

  test('Should return null if value is bigger than min size', () {
    expect(
        sut.validate({'any_field': faker.randomGenerator.string(10, min: 6)}),
        null);
  });
}
