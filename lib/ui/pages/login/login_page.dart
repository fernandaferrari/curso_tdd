import 'package:curso_tdd/ui/components/components.dart';
import 'package:curso_tdd/ui/pages/login/components/components.dart';
import 'package:curso_tdd/ui/pages/pages.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  final ILoginPresenter presenter;

  LoginPage(this.presenter);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  void _hideKeyboard() {
    final currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  @override
  void dispose() {
    super.dispose();
    widget.presenter.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (context) {
        widget.presenter.isLoadStream.listen((isLoading) {
          if (isLoading) {
            showLoading(context);
          } else {
            hideLoading(context);
          }
        });

        widget.presenter.mainErrorStream.listen((mainError) {
          if (mainError != null) {
            showErrorMessage(context, mainError);
          }
        });

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
                'Login'.toUpperCase(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline1,
              ),
              Padding(
                padding: const EdgeInsets.all(32),
                child: Provider(
                  create: (_) => widget.presenter,
                  child: Form(
                      child: Column(
                    children: [
                      EmailInput(),
                      Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 32),
                        child: PasswordInput(),
                      ),
                      LoginButton(),
                      FlatButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.person),
                          label: const Text('Registrar')),
                    ],
                  )),
                ),
              ),
            ],
          )),
        );
      }),
    );
  }
}
