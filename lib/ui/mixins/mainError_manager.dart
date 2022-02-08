import 'package:curso_tdd/ui/components/components.dart';
import 'package:curso_tdd/ui/helpers/helpers.dart';
import 'package:flutter/material.dart';

mixin MainErrorManager {
  void handleError(BuildContext context, Stream<UIError?> stream) {
    stream.listen((mainError) {
      if (mainError != null) {
        showErrorMessage(context, mainError.description);
      }
    });
  }
}
