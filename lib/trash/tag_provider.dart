// import 'package:flutter/material.dart';
//
// class TagProvider extends ChangeNotifier {
//   final List<String> _tagStrings = [];
//   bool showErrorBorder = false; // 状態変数
//
//   List<String> get tagStrings => _tagStrings;
//
//   void addTag(String tag) {
//     _tagStrings.add(tag);
//     notifyListeners();
//   }
//
//   void removeTag(int index) {
//     _tagStrings.removeAt(index);
//     notifyListeners();
//   }
//
//   void clearTags() {
//     _tagStrings.clear();
//     showErrorBorder = false;
//     notifyListeners();
//   }
//
//   void update() {
//     showErrorBorder = false;
//     notifyListeners();
//   }
//
//   void checkAndSetErrorBorder() {
//     // 親ウィジェットで投稿を押したときに、tagStringsがnullまたは空の場合、showErrorBorderをtrueに設定
//     if (_tagStrings.isEmpty) {
//       showErrorBorder = true;
//       notifyListeners();
//     }
//   }
// }
