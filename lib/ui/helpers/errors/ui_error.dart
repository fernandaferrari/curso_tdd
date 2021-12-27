import 'package:curso_tdd/ui/helpers/i18n/i18n.dart';

enum UIError {
  requiredField,
  invalidField,
  unexpected,
  invalidCredentials,
}

extension DomainErrorExtension on UIError {
  String get description {
    switch (this) {
      case UIError.requiredField:
        return R.strings.msgRequiredField;
      case UIError.invalidField:
        return R.strings.msgInvalidField;
      case UIError.invalidCredentials:
        return R.strings.msgInvalidCredentials;
      default:
        return 'Algo errado aconteceu. Tente novamente em breve.';
    }
  }
}
