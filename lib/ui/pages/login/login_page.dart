import 'package:curso_tdd/ui/components/components.dart';
import 'package:curso_tdd/ui/helpers/helpers.dart';
import 'package:curso_tdd/ui/mixins/mixins.dart';
import 'package:curso_tdd/ui/pages/login/components/components.dart';
import 'package:curso_tdd/ui/pages/pages.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget
    with KeyboardManager, LoadingManager, MainErrorManager, NavigateManager {
  final ILoginPresenter presenter;

  LoginPage(this.presenter);

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
                'Login'.toUpperCase(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline1,
              ),
              Padding(
                padding: const EdgeInsets.all(32),
                child: ListenableProvider(
                  create: (_) => presenter,
                  child: Form(
                      child: Column(
                    children: [
                      EmailInput(),
                      Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 32),
                        child: PasswordInput(),
                      ),
                      LoginButton(),
                      TextButton.icon(
                          onPressed: presenter.goToSingUp,
                          icon: const Icon(Icons.person),
                          label: Text(R.strings.addAccount)),
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
