import 'dart:io';

import 'package:flutter/foundation.dart';

import '../models/model/place.dart';

class GreatPlaces with ChangeNotifier {
  List<Place> _items = [];

  //アイテムのコピーを取得できるゲッター
  List<Place> get items {
    return [..._items];
  }

  void addPlace(
    String pickedTitle,
    File pickedImage,
  ) {
    final newPlace = Place(
      id: DateTime.now().toString(),
      Image: pickedImage,
      title: pickedTitle,
    );
    _items.add(newPlace);
    notifyListeners();
  }
}
