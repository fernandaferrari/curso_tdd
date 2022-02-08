import 'package:get/get.dart';

mixin NavigatorManager on GetxController {
  var _navigateTo = Rx<String?>(null);
  Stream<String?> get navigateToStream => _navigateTo.stream;
  set isNavigate(String value) => _navigateTo.subject.add(value);
}
