import 'package:flutter/material.dart';
import 'package:get/get.dart';

mixin SessionManager {
  void handleSessionExpired(BuildContext context, Stream<bool> stream) {
    stream.listen((isExpired) {
      if (isExpired == true) {
        Get.offAllNamed('/login');
      }
    });
  }
}
