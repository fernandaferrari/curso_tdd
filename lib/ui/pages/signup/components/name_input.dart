import 'package:curso_tdd/ui/helpers/helpers.dart';
import 'package:flutter/material.dart';

class NameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
        decoration: InputDecoration(
          labelText: R.strings.name,
          icon: const Icon(
            Icons.person,
          ),
          //errorText: data,
        ),
        keyboardType: TextInputType.name);
  }
}
