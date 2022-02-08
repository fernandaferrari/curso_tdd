import 'package:curso_tdd/presentation/presenter/dependencies/dependencies.dart';
import 'package:mocktail/mocktail.dart';

class ValidationSpy extends Mock implements IValidation {
  ValidationSpy() {
    mockValidation();
  }

  When mockValidationCall(String? field) => when(() => validate(
      field: field == null ? any(named: 'field') : field,
      input: any(named: 'input')));
  void mockValidation({String? field}) =>
      this.mockValidationCall(field).thenReturn(null);
  void mockValidationError({String? field, required ValidationError value}) =>
      this.mockValidationCall(field).thenReturn(value);
}
