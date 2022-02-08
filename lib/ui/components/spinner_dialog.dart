import 'package:flutter/material.dart';

Future<void> showLoading(BuildContext context) async {
  await Future.delayed(Duration.zero);
  await showDialog(
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
}

void hideLoading(BuildContext context) {
  //Navigator.of(context).pop();
  if (Navigator.canPop(context)) {
    Navigator.of(context).pop();
  }
}
