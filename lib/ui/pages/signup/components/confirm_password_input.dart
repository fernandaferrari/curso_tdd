import 'package:curso_tdd/ui/helpers/helpers.dart';
import 'package:flutter/material.dart';

class ConfirmPasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Confirm Password.',
        icon: Icon(Icons.lock),
      ),
      obscureText: true,
    );
  }
}
