import 'package:curso_tdd/presentation/mixins/mixins.dart';
import 'package:curso_tdd/presentation/presenter/dependencies/dependencies.dart';
import 'package:curso_tdd/ui/helpers/errors/ui_error.dart';
import 'package:curso_tdd/ui/pages/pages.dart';
import 'package:get/state_manager.dart';
import 'package:meta/meta.dart';

import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';

class GetxLoginPresenter extends GetxController
    with NavigatorManager, LoadingManager, FormManager, UIErrorManager
    implements ILoginPresenter {
  final IValidation validation;
  final IAuthentication authentication;
  final ISaveCurrentAccount saveCurrentAccount;

  String _email;
  String _password;

  var _emailError = Rx<UIError>();
  var _passwordError = Rx<UIError>();

  Stream<UIError> get emailErrorStream => _emailError.stream;
  Stream<UIError> get passwordErrorStream => _passwordError.stream;

  GetxLoginPresenter(
      {@required this.validation,
      @required this.authentication,
      @required this.saveCurrentAccount});

  void validateEmail(String email) {
    _email = email;
    _emailError.value = _validateField('email');
    _validateForm();
  }

  void validatePassword(String password) {
    _password = password;
    _passwordError.value = _validateField('password');
    _validateForm();
  }

  UIError _validateField(field) {
    final _formData = {
      'email': _email,
      'password': _password,
    };

    final error = validation.validate(field: field, input: _formData);

    switch (error) {
      case ValidationError.invalidField:
        return UIError.invalidField;
      case ValidationError.requiredField:
        return UIError.requiredField;
      default:
        return null;
    }
  }

  void _validateForm() {
    isFormValid = _emailError.value == null &&
        _passwordError.value == null &&
        _email != null &&
        _password != null;
  }

  Future<void> auth() async {
    try {
      mainError = null;
      isLoading = true;
      final account = await authentication
          .auth(AuthenticationParams(email: _email, secret: _password));
      await saveCurrentAccount.save(account);
      isNavigate = '/surveys';
    } on DomainError catch (error) {
      switch (error) {
        case DomainError.invalidCredentials:
          mainError = UIError.invalidCredentials;
          break;
        default:
          mainError = UIError.unexpected;
      }
      isLoading = false;
    }
  }

  @override
  void goToSingUp() {
    isNavigate = '/signup';
  }
}
