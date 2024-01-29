import 'package:flutter/material.dart';

Widget RequiredCustomTextField({
  required String labelText,
  required String hintText,
  required TextEditingController controller,
  required IconData prefixIcon,
  final int? maxLength,
  String? text,
  void Function(String value)? func,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Text.rich(
            TextSpan(
              text: labelText,
              style: const TextStyle(fontSize: 17.0, color: Colors.black),
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Text.rich(
            TextSpan(
              text: "必須",
              style: const TextStyle(fontSize: 13.0, color: Colors.red),
            ),
          ),
        ],
      ),
      TextFormField(
        textInputAction: TextInputAction.next,
        onChanged: (value) => func!(value),
        style: TextStyle(
            color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17),
        controller: controller,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        maxLength: maxLength,
        decoration: InputDecoration(
          filled: true,
          // 背景色を設定するためにtrueに設定
          fillColor: Colors.white12,
          prefixIcon: Icon(
            prefixIcon,
            color: Colors.orange,
          ),
          labelText: hintText,
          hintStyle:
              TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
          labelStyle: TextStyle(
              color: Colors.black, fontWeight: FontWeight.normal, fontSize: 15),
          // border: OutlineInputBorder(),
          // enabledBorder: OutlineInputBorder(
          //   borderSide: BorderSide(color: Colors.black),
          // ),
        ),
      ),
    ],
  );
}

Widget CustomTextField({
  required TextEditingController controller,
  String? text,
  required String labelText,
  required String hintText,
  required IconData prefixIcon,
  int? maxLength,
  void Function(String value)? func,
}) {
  if (text != null) {
    controller.text = text;
  }
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text.rich(
        TextSpan(
          text: labelText,
          style: const TextStyle(fontSize: 17.0, color: Colors.black),
        ),
      ),
      TextFormField(
        textInputAction: TextInputAction.next,
        onChanged: (value) => func!(value),
        style: TextStyle(
            color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold),
        controller: controller,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        maxLength: maxLength ?? null,
        decoration: InputDecoration(
          filled: true,
          // 背景色を設定するためにtrueに設定
          fillColor: Colors.white12,
          prefixIcon: Icon(
            prefixIcon,
            color: Colors.orange,
          ),
          labelText: hintText,
          labelStyle: TextStyle(
              color: Colors.black, fontWeight: FontWeight.normal, fontSize: 15),
          // border: OutlineInputBorder(),
          // enabledBorder: OutlineInputBorder(
          //   borderSide: BorderSide(color: Colors.black),
          // ),
        ),
      ),
    ],
  );
}

Widget CustomTextRich({
  required String mainText,
  required String optionalText,
}) {
  return Row(
    children: [
      Text.rich(
        TextSpan(
          text: mainText,
          style: const TextStyle(fontSize: 17.0, color: Colors.black),
        ),
      ),
      Text.rich(
        TextSpan(
          text: optionalText,
          style: const TextStyle(fontSize: 15.0, color: Colors.black),
        ),
      ),
      SizedBox(
        width: 5,
      ),
      Text.rich(
        TextSpan(
          text: "必須",
          style: const TextStyle(fontSize: 13.0, color: Colors.red),
        ),
      ),
    ],
  );
}

BoxDecoration appBoxDecorationTextField({
  Color color = Colors.grey,
  double radius = 15,
  Color borderColor = Colors.white12,
}) {
  return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: borderColor));
}
