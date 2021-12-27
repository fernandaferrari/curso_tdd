import 'package:curso_tdd/presentation/presenter/dependencies/validation.dart';
import 'package:curso_tdd/validation/validators/validators.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  EmailValidator sut;
  String email;
  setUp(() {
    sut = EmailValidator('any_field');
    email = faker.internet.email();
  });

  test('Should return null if email is empty', () {
    expect(sut.validate(''), null);
  });

  test('Should return null if email is null', () {
    expect(sut.validate(null), null);
  });

  test('Should return null if email isValid', () {
    expect(sut.validate(email), null);
  });

  test('Should return error if email isValid', () {
    expect(sut.validate('fernanda.ferrari'), ValidationError.invalidField);
  });
}
