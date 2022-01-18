import 'package:curso_tdd/main/builders/validation_builder.dart';
import 'package:curso_tdd/presentation/presenter/dependencies/validation.dart';
import 'package:curso_tdd/validation/dependencies/dependencies.dart';
import 'package:curso_tdd/validation/validators/validation_composite.dart';

IValidation makeLoginValidation() {
  return ValidationComposite(makeLoginValidations());
}

List<FieldValidation> makeLoginValidations() {
  return [
    ...ValidationBuilder.field('email').required().email().build(),
    ...ValidationBuilder.field('password').required().min(3).build(),
  ];
}
