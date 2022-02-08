import 'package:curso_tdd/presentation/presenter/dependencies/validation.dart';
import 'package:curso_tdd/validation/validators/validators.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late EmailValidator sut;
  late String email;
  setUp(() {
    sut = EmailValidator('any_field');
    email = faker.internet.email();
  });

  test('Should return null on invalid case', () {
    expect(sut.validate({}), null);
  });

  test('Should return null if email is empty', () {
    expect(sut.validate({'any_field': ''}), null);
  });

  test('Should return null if email is null', () {
    expect(sut.validate({'any_field': null}), null);
  });

  test('Should return null if email isValid', () {
    expect(sut.validate({'any_field': email}), null);
  });

  test('Should return error if email isValid', () {
    expect(sut.validate({'any_field': 'fernanda.ferrari'}),
        ValidationError.invalidField);
  });
}
