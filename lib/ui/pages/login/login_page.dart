import 'package:curso_tdd/ui/components/components.dart';
import 'package:curso_tdd/ui/pages/pages.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  final ILoginPresenter? presenter;

  LoginPage(this.presenter);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const LoginHeader(),
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
            child: Form(
                child: Column(
              children: [
                StreamBuilder<String>(
                    stream: presenter!.emailErrorStream,
                    builder: (context, snapshot) {
                      String? data = snapshot.data;
                      return TextFormField(
                        onChanged: presenter!.validateEmail,
                        decoration: InputDecoration(
                          labelText: 'E-mail',
                          icon: const Icon(
                            Icons.email,
                          ),
                          errorText: data,
                          //errorText: data,
                        ),
                        keyboardType: TextInputType.emailAddress,
                      );
                    }),
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 32),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Senha',
                      icon: Icon(
                        Icons.lock,
                      ),
                    ),
                    obscureText: true,
                    onChanged: presenter!.validatePassword,
                  ),
                ),
                ElevatedButton(
                  onPressed: null,
                  child: Text('Entrar'.toUpperCase()),
                ),
                TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.person),
                    label: const Text('Registrar')),
              ],
            )),
          ),
        ],
      )),
    );
  }
}
