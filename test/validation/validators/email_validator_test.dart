import 'package:curso_tdd/validation/dependencies/field_validation.dart';
import 'package:flutter_test/flutter_test.dart';

class EmailValidator implements FieldValidation {
  @override
  final String field;

  EmailValidator(this.field);

  @override
  String? validate(String? value) {
    return null;
  }
}

void main() {
  late EmailValidator sut;
  setUp(() {
    sut = EmailValidator('any_field');
  });

  test('Should return null if email is empty', () {
    final error = sut.validate('');

    expect(error, null);
  });

  test('Should return null if email is null', () {
    final error = sut.validate(null);

    expect(error, null);
  });
}
