import 'package:flutter/material.dart';

class EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'E-mail',
        icon: const Icon(
          Icons.email,
        ),
        //errorText: data,
      ),
      keyboardType: TextInputType.emailAddress,
    );
  }
}
