import 'package:curso_tdd/data/usecases/usecase.dart';
import 'package:curso_tdd/presentation/presenter/dependencies/validation.dart';
import 'package:curso_tdd/validation/dependencies/dependencies.dart';
import 'package:curso_tdd/validation/validators/email_validator.dart';
import 'package:curso_tdd/validation/validators/required_field_validation.dart';
import 'package:curso_tdd/validation/validators/validation_composite.dart';

IValidation makeLoginValidation() {
  return ValidationComposite(makeLoginValidations());
}

List<FieldValidation> makeLoginValidations() {
  return [
    RequiredFieldValidation('email'),
    EmailValidator('email'),
    RequiredFieldValidation('password')
  ];
}
