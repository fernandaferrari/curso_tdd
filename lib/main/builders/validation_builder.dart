import 'package:curso_tdd/validation/dependencies/field_validation.dart';
import 'package:curso_tdd/validation/validators/validators.dart';

class ValidationBuilder {
  static ValidationBuilder? _instance;
  String fieldName;
  List<FieldValidation> validations = [];

  ValidationBuilder._(this.fieldName);

  static ValidationBuilder field(String fieldName) {
    _instance = ValidationBuilder._(fieldName);
    return _instance!;
  }

  ValidationBuilder required() {
    validations.add(RequiredFieldValidation(fieldName));
    return this;
  }

  ValidationBuilder email() {
    validations.add(EmailValidator(fieldName));
    return this;
  }

  ValidationBuilder min(int size) {
    validations.add(MinLengthValidation(field: fieldName, size: size));
    return this;
  }

  ValidationBuilder sameAs(String fieldToCompare) {
    validations.add(CompareFieldValidation(
        field: fieldName, fieldToCompare: fieldToCompare));
    return this;
  }

  List<FieldValidation> build() => validations;
}
