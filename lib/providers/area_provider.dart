import 'package:flutter/material.dart';

class AreaProvider extends ChangeNotifier {
  String _selectedValue = "";

  String get selectedValue => _selectedValue;

  void setSelectedValue(String value) {
    _selectedValue = value;
    notifyListeners();
  }

  void clearTags() {
    _selectedValue = "";
    notifyListeners();
  }
}
