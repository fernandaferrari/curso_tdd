import 'package:curso_tdd/ui/helpers/helpers.dart';
import 'package:curso_tdd/ui/pages/signup/signup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<SignUpPresenter>(context);
    return StreamBuilder<UIError>(
        stream: presenter.nameErrorStream,
        builder: (context, snapshot) {
          return TextFormField(
            onChanged: presenter.validateName,
            decoration: InputDecoration(
              labelText: 'Nome',
              icon: const Icon(
                Icons.person,
              ),
              errorText: snapshot.hasData ? snapshot.data.description : null,
              //errorText: data,
            ),
            keyboardType: TextInputType.name,
          );
        });
  }
}
