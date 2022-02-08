import 'package:get/get.dart';

mixin NavigateManager {
  void handleNavigate(Stream<String?> stream, {bool clear = false}) {
    stream.listen((page) {
      if (page != null && page.isNotEmpty) {
        if (clear == true) {
          Get.offAllNamed(page);
        } else {
          Get.toNamed(page);
        }
      }
    });
  }
}
