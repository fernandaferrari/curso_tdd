import 'package:curso_tdd/validation/dependencies/field_validation.dart';
import 'package:curso_tdd/validation/validators/email_validator.dart';
import 'package:curso_tdd/validation/validators/required_field_validation.dart';

class ValidationBuilder {
  static ValidationBuilder _instance;
  String fieldName;
  List<FieldValidation> validations = [];

  static ValidationBuilder field(String fieldName) {
    _instance = ValidationBuilder();
    _instance.fieldName = fieldName;
    return _instance;
  }

  ValidationBuilder required() {
    validations.add(RequiredFieldValidation(fieldName));
    return this;
  }

  ValidationBuilder email() {
    validations.add(EmailValidator(fieldName));
    return this;
  }

  List<FieldValidation> build() => validations;
}
