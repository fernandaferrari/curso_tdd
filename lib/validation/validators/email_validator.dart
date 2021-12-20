import 'package:curso_tdd/validation/dependencies/dependencies.dart';
import 'package:equatable/equatable.dart';

class EmailValidator extends Equatable implements FieldValidation {
  @override
  final String field;

  EmailValidator(this.field);

  @override
  String validate(String value) {
    final regex = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    final isValid = value?.isNotEmpty != true || regex.hasMatch(value);
    return isValid ? null : 'Campo inválido.';
  }

  @override
  List<Object> get props => [field];
}
