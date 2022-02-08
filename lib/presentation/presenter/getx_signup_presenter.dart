import 'package:curso_tdd/domain/helpers/helpers.dart';
import 'package:curso_tdd/presentation/mixins/mixins.dart';
import 'package:get/state_manager.dart';

import 'package:curso_tdd/domain/usecases/usecases.dart';
import 'package:curso_tdd/presentation/presenter/dependencies/dependencies.dart';
import 'package:curso_tdd/ui/helpers/errors/ui_error.dart';
import 'package:curso_tdd/ui/pages/pages.dart';

class GetxSignUpPresenter extends GetxController
    with NavigatorManager, LoadingManager, FormManager, UIErrorManager
    implements SignUpPresenter {
  final IValidation validation;
  final AddAccount addAccount;
  final ISaveCurrentAccount saveCurrentAccount;

  String? _email;
  String? _password;
  String? _confirmPassword;
  String? _name;

  var _nameError = Rx<UIError?>(null);
  var _emailError = Rx<UIError?>(null);
  var _passwordError = Rx<UIError?>(null);
  var _confirmPasswordError = Rx<UIError?>(null);

  GetxSignUpPresenter({
    required this.validation,
    required this.addAccount,
    required this.saveCurrentAccount,
  });

  Stream<UIError?> get emailErrorStream => _emailError.stream;
  Stream<UIError?> get passwordErrorStream => _passwordError.stream;
  Stream<UIError?> get confirmPasswordErrorStream =>
      _confirmPasswordError.stream;
  Stream<UIError?> get nameErrorStream => _nameError.stream;

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

  @override
  void validateConfirmPassword(String confirmPassword) {
    _confirmPassword = confirmPassword;
    _confirmPasswordError.value = _validateField('confirm_password');
    _validateForm();
  }

  @override
  void validateName(String name) {
    _name = name;
    _nameError.value = _validateField('name');
    _validateForm();
  }

  UIError? _validateField(String field) {
    final _formData = {
      'name': _name,
      'email': _email,
      'password': _password,
      'confirm_password': _confirmPassword,
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
        _password != null &&
        _nameError.value == null &&
        _name != null &&
        _confirmPasswordError.value == null &&
        _confirmPassword != null;
  }

  @override
  Future<void> signup() async {
    try {
      mainError = null;
      isLoading = true;
      final account = await addAccount.add(AddAccountParams(
          email: _email!,
          password: _password!,
          name: _name!,
          passwordConfirmation: _confirmPassword!));

      await saveCurrentAccount.save(account);
      isNavigate = '/surveys';
    } on DomainError catch (error) {
      switch (error) {
        case DomainError.invalidCredentials:
          mainError = UIError.invalidCredentials;
          break;

        case DomainError.emailInUse:
          mainError = UIError.emailInUse;
          break;
        default:
          mainError = UIError.unexpected;
          break;
      }
      isLoading = false;
    }
  }

  @override
  void goToLogin() {
    isNavigate = '/login';
  }
}
