import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  final String? title; // オプショナルに変更
  final String? message; // オプショナルに変更
  final String confirmButtonText;
  final String cancelButtonText;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const CustomAlertDialog({
    Key? key,
    this.title, // requiredを削除
    this.message, // requiredを削除
    required this.confirmButtonText,
    this.cancelButtonText = "キャンセル",
    required this.onConfirm,
    required this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: title != null
          ? Text(
              title!,
              style: TextStyle(color: Colors.indigo),
            )
          : null, // titleがnullでない場合のみ表示
      content: message != null
          ? Text(
              message!,
              style: TextStyle(color: Colors.black),
            )
          : null, // messageがnullでない場合のみ表示
      actions: <Widget>[
        TextButton(
          onPressed: onCancel,
          child: Text(
            cancelButtonText,
            style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold),
          ),
        ),
        TextButton(
          onPressed: onConfirm,
          child: Text(
            confirmButtonText,
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
