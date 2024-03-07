import 'package:flutter/material.dart';

Future<void> showUpDis(context, String mess, String message) {
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return AlertDialog(
        title: Text(mess),
        content: Text(message),
      );
    },
  );
}

Future<void> showUpUnDis(context, String message, String message1) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        title: Text(message),
        content: Text(message1),
      );
    },
  );
}

Future<void> checkEmail(context, String message, String message1) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        title: Text(message),
        content: Text(message1),
        actions: [
          TextButton(
            child: Text('ok'.toUpperCase(),),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}