import 'package:curso_tdd/presentation/presenter/dependencies/dependencies.dart';
import 'package:curso_tdd/validation/dependencies/dependencies.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class CompareFieldValidation extends Equatable implements FieldValidation {
  final String field;
  final String fieldToCompare;

  CompareFieldValidation({@required this.field, @required this.fieldToCompare});

  @override
  ValidationError validate(Map input) {
    return input[field] == input[fieldToCompare]
        ? null
        : ValidationError.invalidField;
  }

  @override
  List get props => [field, fieldToCompare];
}
