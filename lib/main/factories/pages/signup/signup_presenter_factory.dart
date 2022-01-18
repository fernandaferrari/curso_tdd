import 'package:curso_tdd/main/factories/pages/signup/signup.dart';
import 'package:curso_tdd/main/factories/usercases/usecases.dart';
import 'package:curso_tdd/presentation/presenter/presenter.dart';
import 'package:curso_tdd/ui/pages/pages.dart';

SignUpPresenter makeGetxSignUpPresenter() {
  return GetxSignUpPresenter(
    addAccount: makeRemoteAddAccount(),
    validation: makeSignUpValidation(),
    saveCurrentAccount: makeLocalSaveCurrentAccount(),
  );
}
