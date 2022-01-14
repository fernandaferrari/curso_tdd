import 'package:curso_tdd/ui/components/components.dart';
import 'package:curso_tdd/ui/helpers/helpers.dart';
import 'package:curso_tdd/ui/pages/signup/components/components.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    void _hideKeyboard() {
      final currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
    }

    return Scaffold(
      body: Builder(builder: (context) {
        return GestureDetector(
          onTap: _hideKeyboard,
          child: SingleChildScrollView(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              LoginHeader(),
              const SizedBox(
                height: 32,
              ),
              Text(
                R.strings.addAccount.toUpperCase(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline1,
              ),
              Padding(
                padding: const EdgeInsets.all(32),
                child: Form(
                    child: Column(
                  children: [
                    NameInput(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                      ),
                      child: EmailInput(),
                    ),
                    PasswordInput(),
                    Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 32),
                      child: ConfirmPasswordInput(),
                    ),
                    SignUpButton(),
                    FlatButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.exit_to_app),
                        label: Text(R.strings.login)),
                  ],
                )),
              ),
            ],
          )),
        );
      }),
    );
  }
}
