import 'package:curso_tdd/ui/helpers/helpers.dart';
import 'package:curso_tdd/ui/pages/signup/signup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConfirmPasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<SignUpPresenter>(context);
    return StreamBuilder<UIError?>(
        stream: presenter.confirmPasswordErrorStream,
        builder: (context, snapshot) {
          return TextFormField(
            decoration: InputDecoration(
              labelText: 'Confirmar senha.',
              icon: Icon(Icons.lock),
              errorText: snapshot.data?.description,
            ),
            obscureText: true,
            onChanged: presenter.validateConfirmPassword,
          );
        });
  }
}
