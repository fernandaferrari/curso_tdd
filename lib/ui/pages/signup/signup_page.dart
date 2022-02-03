import 'package:curso_tdd/ui/mixins/mixins.dart';
import 'package:flutter/material.dart';

import 'package:curso_tdd/ui/components/components.dart';
import 'package:curso_tdd/ui/helpers/helpers.dart';
import 'package:curso_tdd/ui/pages/signup/components/components.dart';
import 'package:curso_tdd/ui/pages/signup/signup_presenter.dart';
import 'package:meta/meta.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatelessWidget
    with KeyboardManager, LoadingManager, MainErrorManager, NavigateManager {
  final SignUpPresenter presenter;

  SignUpPage({
    @required this.presenter,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (context) {
        handleLoading(context, presenter.isLoadStream);
        handleError(context, presenter.mainErrorStream);
        handleNavigate(presenter.navigateToStream, clear: true);
        return GestureDetector(
          onTap: () => hideKeyboard(context),
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
                child: Provider(
                  create: (_) => presenter,
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
                          onPressed: presenter.goToLogin,
                          icon: const Icon(Icons.exit_to_app),
                          label: Text(R.strings.login)),
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
