import 'package:curso_tdd/ui/pages/pages.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color.fromRGBO(136, 14, 79, 1);
    const primaryColorDark = Color.fromRGBO(96, 0, 39, 1);
    const primaryColorLight = Color.fromRGBO(188, 71, 123, 1);

    // final ButtonThemeData raisedButtonSyle = ButtonThemeData(
    //   colorScheme: ColorScheme.light(primary: primaryColor),
    //           buttonColor: primaryColor,
    //           splashColor: primaryColorLight,
    //           padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
    //           textTheme: ButtonTextTheme.primary,
    //           shape: RoundedRectangleBorder(
    //               borderRadius: BorderRadius.circular(20)),
    // );

    return MaterialApp(
      title: 'TDD',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: primaryColor,
        primaryColorDark: primaryColorDark,
        primaryColorLight: primaryColorLight,
        colorScheme: ColorScheme.fromSwatch(accentColor: primaryColor),
        backgroundColor: Colors.white,
        textTheme: const TextTheme(
            headline1: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: primaryColorDark)),
        inputDecorationTheme: const InputDecorationTheme(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: primaryColorLight),
          ),
          focusedBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: primaryColor)),
        ),
        // elevatedButtonTheme: ElevatedButtonThemeData(
        //   style: raisedButtonSyle,
        // ),
      ),
      home: LoginPage(null),
    );
  }
}
