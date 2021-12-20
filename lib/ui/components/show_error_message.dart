import 'package:flutter/material.dart';

void showErrorMessage(BuildContext context, String mainError) {
  Scaffold.of(context).showSnackBar(SnackBar(
    content: Text(
      mainError,
      textAlign: TextAlign.center,
    ),
    backgroundColor: Colors.red[900],
  ));
}
