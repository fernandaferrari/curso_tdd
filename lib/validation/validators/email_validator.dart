import 'package:curso_tdd/presentation/presenter/dependencies/dependencies.dart';
import 'package:curso_tdd/validation/dependencies/dependencies.dart';
import 'package:equatable/equatable.dart';

class EmailValidator extends Equatable implements FieldValidation {
  @override
  final String field;

  EmailValidator(this.field);

  @override
  ValidationError? validate(Map input) {
    final regex = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    final isValid =
        input[field]?.isNotEmpty != true || regex.hasMatch(input[field]);
    return isValid ? null : ValidationError.invalidField;
  }

  @override
  List<Object> get props => [field];
}
