import 'package:curso_tdd/presentation/presenter/dependencies/dependencies.dart';
import 'package:curso_tdd/validation/dependencies/dependencies.dart';
import 'package:equatable/equatable.dart';

class CompareFieldValidation extends Equatable implements FieldValidation {
  final String field;
  final String fieldToCompare;

  CompareFieldValidation({required this.field, required this.fieldToCompare});

  @override
  ValidationError? validate(Map input) => input[field] != null &&
          input[fieldToCompare] != null &&
          input[field] != input[fieldToCompare]
      ? ValidationError.invalidField
      : null;

  @override
  List get props => [field, fieldToCompare];
}
