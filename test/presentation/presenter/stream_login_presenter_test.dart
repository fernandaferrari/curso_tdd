import 'package:curso_tdd/presentation/presenter/dependencies/dependencies.dart';
import 'package:curso_tdd/presentation/presenter/presenter.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class ValidationMock extends Mock implements IValidation {}

void main() {
  ValidationMock? validation;
  StreamLoginPresenter? sut;
  late String email;

  When mockValidationCall(String field) => when(() => validation!.validate(
      field: field.isEmpty ? any(named: "field") : field,
      value: any(named: "value")));

  void mockValidation({String? field, String? value}) {
    mockValidationCall(field ?? '').thenReturn(value ?? '');
  }

  setUp(() {
    validation = ValidationMock();
    sut = StreamLoginPresenter(validation: validation!);
    email = faker.internet.email();
    mockValidation();
  });

  test('Validação email quando o email for correto', () {
    sut!.validateEmail(email);

    verify(() => validation!.validate(field: 'email', value: email)).called(1);
  });

  test('Should emit email error if validation fails', () {
    mockValidation(value: 'error');

    sut!.emailErrorStream
        .listen(expectAsync1((error) => expect(error, 'error')));

    sut!.validateEmail(email);
    sut!.validateEmail(email);
  });
}
