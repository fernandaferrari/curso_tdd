import 'package:curso_tdd/presentation/mixins/mixins.dart';
import 'package:curso_tdd/domain/usecases/usecases.dart';
import 'package:curso_tdd/ui/pages/pages.dart';
import 'package:get/get.dart';

class GetxSplashPresenter extends GetxController
    with NavigatorManager
    implements SplashPresenter {
  final LoadCurrentAccount loadCurrentAccount;
  GetxSplashPresenter({
    required this.loadCurrentAccount,
  });

  @override
  Future<void> checkAccount() async {
    await Future.delayed(Duration(seconds: 2));
    try {
      await loadCurrentAccount.load();
      isNavigate = '/surveys';
    } catch (error) {
      isNavigate = '/login';
    }
  }
}
