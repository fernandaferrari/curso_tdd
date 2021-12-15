import 'package:curso_tdd/ui/pages/pages.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class ValidationMock extends Mock implements IValidation {}

abstract class IValidation {
  String? validate({required String field, required String value});
}

class StreamLoginPresenter {
  final IValidation validation;

  StreamLoginPresenter({required this.validation});
  void validateEmail(String email) {
    validation.validate(field: 'email', value: email);
  }
}

void main() {
  ValidationMock? validation;
  StreamLoginPresenter? sut;
  late String email;

  setUp(() {
    validation = ValidationMock();
    sut = StreamLoginPresenter(validation: validation!);
    email = faker.internet.email();
  });

  test('Validação email quando o email for correto', () {
    sut!.validateEmail(email);

    verify(validation!.validate(field: 'email', value: email)).called(1);
  });
}
