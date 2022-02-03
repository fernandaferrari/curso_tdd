import 'package:get/get.dart';

mixin NavigatorManager on GetxController {
  var _navigateTo = RxString();
  Stream<String> get navigateToStream => _navigateTo.stream;
  set isNavigate(String value) => _navigateTo.value = value;
}
