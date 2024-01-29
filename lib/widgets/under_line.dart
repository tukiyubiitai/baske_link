import 'package:flutter/material.dart';

Widget UnderLine() {
  return Container(
    decoration: const BoxDecoration(
      border: Border(
        bottom: BorderSide(color: Colors.black12, width: 1.0), // 下線
      ),
    ),
  );
}
