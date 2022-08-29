import 'package:flutter/material.dart';

enum Message { success, error, info, warning }

class CustomSnackBar {
  static void snackBar(BuildContext context,
      {required String text, required Message message}) {
    const color = Colors.white;
    Color bgColor;
    switch (message) {
      case Message.warning:
        bgColor = Colors.orange[900]!;
        break;
      case Message.error:
        bgColor = Colors.red[900]!;
        break;
      case Message.info:
        bgColor = Colors.blue;
        break;
      default:
        bgColor = Colors.teal;
    }

    ScaffoldMessenger.maybeOf(context)!.showSnackBar(SnackBar(
      content: Text(
        text,
        style: const TextStyle(color: color),
      ),
      backgroundColor: bgColor,
      duration: const Duration(seconds: 3),
    ));
  }
}
