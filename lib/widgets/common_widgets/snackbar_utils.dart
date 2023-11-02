import 'package:flutter/material.dart';

void showSnackBar({
  required BuildContext context,
  required String text,
  required Color backgroundColor,
  required Color textColor,
}) {
  final snackBar = SnackBar(
    content: Text(
      text,
      style: TextStyle(
        color: textColor,
      ),
    ),
    backgroundColor: backgroundColor,
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void showErrorSnackBar({
  required BuildContext context,
  required String text,
}) {
  final snackBar = SnackBar(
    content: Text(
      text,
      style: const TextStyle(
        color: Colors.white,
      ),
    ),
    backgroundColor: Colors.red,
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
