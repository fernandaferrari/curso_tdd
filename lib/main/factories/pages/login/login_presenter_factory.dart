import 'package:curso_tdd/data/usecases/usecase.dart';
import 'package:curso_tdd/main/factories/pages/login/login.dart';
import 'package:curso_tdd/main/factories/usercases/usecases.dart';
import 'package:curso_tdd/presentation/presenter/stream_login_presenter.dart';
import 'package:curso_tdd/ui/pages/pages.dart';

ILoginPresenter makeStreamLoginPresenter() {
  return StreamLoginPresenter(
    authentication: makeRemoteAuthentication(),
    validation: makeLoginValidation(),
  );
}

ILoginPresenter makeGetxLoginPresenter() {
  return StreamLoginPresenter(
    authentication: makeRemoteAuthentication(),
    validation: makeLoginValidation(),
  );
}
