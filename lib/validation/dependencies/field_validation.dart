import 'package:curso_tdd/presentation/presenter/dependencies/dependencies.dart';

abstract class FieldValidation {
  String get field;
  ValidationError? validate(Map input);
}
