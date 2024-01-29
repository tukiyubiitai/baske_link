import 'package:flutter/material.dart';

Widget backButton(BuildContext context) {
  return BackButton(
    color: Colors.white,
    onPressed: () {
      Navigator.pop(context); // 画面遷移を戻る処理
    },
  );
}
