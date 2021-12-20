import 'package:curso_tdd/validation/dependencies/dependencies.dart';
import 'package:equatable/equatable.dart';

class RequiredFieldValidation extends Equatable implements FieldValidation {
  @override
  final String field;

  RequiredFieldValidation(this.field);

  @override
  String validate(String value) {
    return value?.isNotEmpty == true ? null : 'Campo obrigatório.';
  }

  @override
  List<Object> get props => [field];
}
