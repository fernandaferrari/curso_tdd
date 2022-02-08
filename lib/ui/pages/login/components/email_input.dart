import 'package:curso_tdd/ui/helpers/errors/ui_error.dart';
import 'package:curso_tdd/ui/pages/login/login_presenter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<ILoginPresenter>(context);
    return StreamBuilder<UIError?>(
        stream: presenter.emailErrorStream,
        builder: (context, snapshot) {
          return TextFormField(
            onChanged: presenter.validateEmail,
            decoration: InputDecoration(
              labelText: 'E-mail',
              icon: const Icon(
                Icons.email,
              ),
              errorText: snapshot.data?.description,
              //errorText: data,
            ),
            keyboardType: TextInputType.emailAddress,
          );
        });
  }
}
