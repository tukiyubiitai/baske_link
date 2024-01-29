import 'package:flutter/material.dart';

Widget CustomTextFiled({
  void Function(String value)? func,
  required TextEditingController controller,
}) {
  return TextField(
    onChanged: (value) {
      func!(value);
      print(value);
    },
    style: TextStyle(
      fontWeight: FontWeight.bold,
    ),
    maxLength: 10,
    controller: controller,
    decoration: InputDecoration(
      hintText: "ユーザー名 (必須)",
      hintStyle:
          const TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
    ),
  );
}
