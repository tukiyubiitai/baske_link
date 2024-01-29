// import 'package:flutter/material.dart';
//
// class AreaProvider extends ChangeNotifier {
//   String _selectedValue = "";
//   bool showErrorBorder = false; // 状態変数
//
//   String get selectedValue => _selectedValue;
//
//   void setSelectedValue(String value) {
//     _selectedValue = value;
//     notifyListeners();
//   }
//
//   void clearTags() {
//     _selectedValue = "";
//     notifyListeners();
//   }
//
//   void checkAndSetErrorBorder() {
//     // 親ウィジェットで投稿を押したときに、tagStringsがnullまたは空の場合、showErrorBorderをtrueに設定
//     if (_selectedValue.isEmpty) {
//       showErrorBorder = true;
//       notifyListeners();
//     }
//   }
// }
