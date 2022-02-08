import 'package:curso_tdd/ui/helpers/errors/ui_error.dart';
import 'package:curso_tdd/ui/pages/login/login_presenter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<ILoginPresenter>(context);
    return StreamBuilder<UIError?>(
        stream: presenter.passwordErrorStream,
        builder: (context, snapshot) {
          return TextFormField(
            decoration: InputDecoration(
              labelText: 'Password',
              icon: Icon(Icons.lock),
              errorText: snapshot.data?.description,
            ),
            obscureText: true,
            onChanged: presenter.validatePassword,
          );
        });
  }
}
