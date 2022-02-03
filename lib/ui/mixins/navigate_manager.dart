import 'package:get/get.dart';

mixin NavigateManager {
  void handleNavigate(Stream<String> stream, {bool clear = false}) {
    stream.listen((page) {
      if (page?.isNotEmpty == true) {
        if (clear == true) {
          Get.offAllNamed(page);
        } else {
          Get.toNamed(page);
        }
      }
    });
  }
}
