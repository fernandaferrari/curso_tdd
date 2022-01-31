import 'package:curso_tdd/main/builders/validation_builder.dart';
import 'package:curso_tdd/presentation/presenter/dependencies/validation.dart';
import 'package:curso_tdd/validation/dependencies/dependencies.dart';
import 'package:curso_tdd/main/composites/validation_composite.dart';

IValidation makeSignUpValidation() {
  return ValidationComposite(makeSignUpValidations());
}

List<FieldValidation> makeSignUpValidations() {
  return [
    ...ValidationBuilder.field('name').required().min(3).build(),
    ...ValidationBuilder.field('email').required().email().build(),
    ...ValidationBuilder.field('password').required().min(3).build(),
    ...ValidationBuilder.field('confirm_password')
        .required()
        .sameAs('password')
        .build()
  ];
}
