import 'package:flutter/material.dart';

// リストタイルのビルド用関数
Widget buildReportListTile<T>({
  required T reason,
  required T currentReason,
  required Function(T?) onChanged,
  required String Function(T) reasonToString,
}) {
  return ListTile(
    title: Text(reasonToString(reason)),
    leading: Radio<T>(
      value: reason,
      groupValue: currentReason,
      onChanged: onChanged,
    ),
  );
}

// その他の理由用テキストフィールド
Widget buildOtherReasonField(TextEditingController controller) {
  return TextField(
    controller: controller,
    maxLines: 3,
    maxLength: 100,
    decoration: InputDecoration(
      border: OutlineInputBorder(),
      hintText: '詳細を書いてください（任意）',
      hintStyle: TextStyle(fontSize: 13),
    ),
  );
}

// レポートボタン
Widget buildReportButton({
  required BuildContext context,
  required String buttonText,
  required Color buttonColor,
  required Function onPressed,
}) {
  return ElevatedButton(
    onPressed: () => onPressed(),
    child: Text(buttonText,
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
    style: ElevatedButton.styleFrom(
      backgroundColor: buttonColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
      ),
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
    ),
  );
}
