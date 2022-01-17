import 'package:curso_tdd/presentation/presenter/dependencies/dependencies.dart';
import 'package:curso_tdd/validation/dependencies/dependencies.dart';
import 'package:meta/meta.dart';

class MinLengthValidation implements FieldValidation {
  final String field;
  final int size;
  MinLengthValidation({
    @required this.field,
    @required this.size,
  });

  @override
  ValidationError validate(String value) {
    return value != null && value.length >= size
        ? null
        : ValidationError.requiredField;
  }
}
