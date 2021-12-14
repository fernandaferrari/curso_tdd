import 'package:curso_tdd/ui/components/components.dart';
import 'package:curso_tdd/ui/pages/pages.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  final ILoginPresenter? presenter;

  LoginPage(this.presenter);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (context) {
        presenter!.isLoadStream!.listen((isLoading) {
          if (isLoading) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => SimpleDialog(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      CircularProgressIndicator(),
                      SizedBox(
                        height: 18,
                      ),
                      Text(
                        'Aguarde ...',
                        textAlign: TextAlign.center,
                      )
                    ],
                  )
                ],
              ),
            );
          } else {
            Navigator.of(context).pop();
            //if(Navigator.canPop(context){Navigator.of(context).pop();})
          }
        });

        presenter!.mainErrorStream!.listen((mainError) {
          if (mainError.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                mainError,
                textAlign: TextAlign.center,
              ),
              backgroundColor: Colors.red[900],
            ));
          }
        });

        return SingleChildScrollView(
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
                            errorText: data == '' ? '' : data,
                            //errorText: data,
                          ),
                          keyboardType: TextInputType.emailAddress,
                        );
                      }),
                  Padding(
                    padding: EdgeInsets.only(top: 8, bottom: 32),
                    child: StreamBuilder<String>(
                        stream: presenter!.passwordErrorStream,
                        builder: (context, snapshot) {
                          return TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Senha',
                              icon: Icon(Icons.lock),
                              errorText: snapshot.data,
                            ),
                            obscureText: true,
                            onChanged: presenter!.validatePassword,
                          );
                        }),
                  ),
                  StreamBuilder<bool>(
                      stream: presenter!.isFormValidStream,
                      builder: (context, snapshot) {
                        bool? data = snapshot.data;
                        return ElevatedButton(
                          onPressed: data == true ? presenter!.auth : null,
                          child: Text('Entrar'.toUpperCase()),
                        );
                      }),
                  TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.person),
                      label: const Text('Registrar')),
                ],
              )),
            ),
          ],
        ));
      }),
    );
  }
}
