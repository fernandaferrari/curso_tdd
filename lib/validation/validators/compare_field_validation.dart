import 'package:curso_tdd/presentation/presenter/dependencies/dependencies.dart';
import 'package:curso_tdd/validation/dependencies/dependencies.dart';
import 'package:meta/meta.dart';

class CompareFieldValidation implements FieldValidation {
  final String field;
  final String valueToCompare;

  CompareFieldValidation({@required this.field, @required this.valueToCompare});

  @override
  ValidationError validate(String value) {
    return value == valueToCompare ? null : ValidationError.invalidField;
  }
}
