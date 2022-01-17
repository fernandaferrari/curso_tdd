import 'package:curso_tdd/ui/helpers/helpers.dart';
import 'package:curso_tdd/ui/pages/signup/signup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<SignUpPresenter>(context);
    return StreamBuilder<UIError>(
        stream: presenter.emailErrorStream,
        builder: (context, snapshot) {
          return TextFormField(
            onChanged: presenter.validateEmail,
            decoration: InputDecoration(
              labelText: 'E-mail',
              icon: const Icon(
                Icons.email,
              ),
              errorText: snapshot.hasData ? snapshot.data.description : null,
              //errorText: data,
            ),
            keyboardType: TextInputType.emailAddress,
          );
        });
  }
}
