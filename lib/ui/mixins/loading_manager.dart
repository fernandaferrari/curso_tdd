import 'package:curso_tdd/ui/components/components.dart';
import 'package:flutter/material.dart';

mixin LoadingManager {
  void handleLoading(BuildContext context, Stream<bool> stream) {
    stream.listen((isLoading) {
      if (isLoading == true) {
        showLoading(context);
      } else {
        hideLoading(context);
      }
    });
  }
}
