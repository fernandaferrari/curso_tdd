import 'package:curso_tdd/ui/pages/signup/signup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<SignUpPresenter>(context);
    return StreamBuilder<bool>(builder: (context, snapshot) {
      return RaisedButton(
        child: Text('Cadastrar'.toUpperCase()),
      );
    });
  }
}
