import 'package:flutter_test/flutter_test.dart';

abstract class FieldValidation {
  String get field;
  String? validate(String value);
}

class RequiredFieldValidation implements FieldValidation {
  @override
  final String field;

  RequiredFieldValidation(this.field);

  @override
  String? validate(String value) {
    return value.isEmpty ? 'Campo obrigatório.' : null;
  }
}

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
}
