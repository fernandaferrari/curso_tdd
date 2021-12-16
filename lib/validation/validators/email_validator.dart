import 'package:curso_tdd/validation/dependencies/dependencies.dart';

class EmailValidator implements FieldValidation {
  @override
  final String field;

  EmailValidator(this.field);

  @override
  String? validate(String? value) {
    final regex = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    final isValid = value?.isNotEmpty != true || regex.hasMatch(value!);
    return isValid ? null : 'Campo inválido.';
  }
}
