import 'package:curso_tdd/domain/helpers/helpers.dart';
import 'package:get/state_manager.dart';
import 'package:meta/meta.dart';

import 'package:curso_tdd/domain/usecases/usecases.dart';
import 'package:curso_tdd/presentation/presenter/dependencies/dependencies.dart';
import 'package:curso_tdd/ui/helpers/errors/ui_error.dart';
import 'package:curso_tdd/ui/pages/pages.dart';

class GetxSignUpPresenter extends GetxController implements SignUpPresenter {
  final IValidation validation;
  final AddAccount addAccount;
  final ISaveCurrentAccount saveCurrentAccount;

  String _email;
  String _password;
  String _confirmPassword;
  String _name;

  var _nameError = Rx<UIError>();
  var _emailError = Rx<UIError>();
  var _passwordError = Rx<UIError>();
  var _confirmPasswordError = Rx<UIError>();
  var _mainError = Rx<UIError>();
  var _navigateTo = RxString();
  var _isFormValid = false.obs;
  var _isLoading = false.obs;

  GetxSignUpPresenter({
    @required this.validation,
    @required this.addAccount,
    @required this.saveCurrentAccount,
  });

  Stream<UIError> get emailErrorStream => _emailError.stream;
  Stream<UIError> get passwordErrorStream => _passwordError.stream;
  Stream<UIError> get mainErrorStream => _mainError.stream;
  Stream<String> get navigateToStream => _navigateTo.stream;
  Stream<bool> get isFormValidStream => _isFormValid.stream;
  Stream<bool> get isLoadStream => _isLoading.stream;
  Stream<UIError> get confirmPasswordErrorStream =>
      _confirmPasswordError.stream;
  Stream<UIError> get nameErrorStream => _nameError.stream;

  void validateEmail(String email) {
    _email = email;
    _emailError.value = _validateField(field: 'email', value: email);
    _validateForm();
  }

  void validatePassword(String password) {
    _password = password;
    _passwordError.value = _validateField(field: 'password', value: password);
    _validateForm();
  }

  @override
  void validateConfirmPassword(String confirmPassword) {
    _confirmPassword = confirmPassword;
    _confirmPasswordError.value =
        _validateField(field: 'confirm_password', value: confirmPassword);
    _validateForm();
  }

  @override
  void validateName(String name) {
    _name = name;
    _nameError.value = _validateField(field: 'name', value: name);
    _validateForm();
  }

  UIError _validateField({String field, String value}) {
    final error = validation.validate(field: field, value: value);

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
    _isFormValid.value = _emailError.value == null &&
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
      _isLoading.value = true;
      final account = await addAccount.add(AddAccountParams(
          email: _email,
          password: _password,
          name: _name,
          passwordConfirmation: _confirmPassword));

      saveCurrentAccount.save(account);
    } on DomainError catch (error) {
      switch (error) {
        case DomainError.invalidCredentials:
          _mainError.value = UIError.invalidCredentials;
          break;
        default:
          _mainError.value = UIError.unexpected;
      }
      _isLoading.value = false;
    }
  }
}
