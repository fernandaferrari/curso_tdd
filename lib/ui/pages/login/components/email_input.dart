import 'package:curso_tdd/ui/pages/login/login_presenter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<ILoginPresenter>(context);
    return StreamBuilder<String?>(
        stream: presenter.emailErrorStream,
        builder: (context, snapshot) {
          String? data = snapshot.data;
          return TextFormField(
            onChanged: presenter.validateEmail,
            decoration: InputDecoration(
              labelText: 'E-mail',
              icon: const Icon(
                Icons.email,
              ),
              errorText: data == '' ? '' : data,
              //errorText: data,
            ),
            keyboardType: TextInputType.emailAddress,
          );
        });
  }
}
