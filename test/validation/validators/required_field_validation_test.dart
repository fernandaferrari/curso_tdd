import 'package:curso_tdd/validation/validators/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late RequiredFieldValidation sut;

  setUp(() {
    sut = RequiredFieldValidation('any_value');
  });

  test('should return null if value is not empty', () {
    expect(sut.validate('any_value'), null);
  });

  test('should return error if value is empty', () {
    expect(sut.validate(''), 'Campo obrigatório.');
  });

  test('should return error if value is null', () {
    expect(sut.validate(null), 'Campo obrigatório.');
  });
}
