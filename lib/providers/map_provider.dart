import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MapModel extends ChangeNotifier {
  List<String> urls = [];
  List<String> bodyUrls = [];

  Future<void> fetchPhoto(String placeId) async {
    //Google Maps Places APIの詳細情報を取得
    // placeRes --> APIからのレスポンス
    final placeRes = await http.get(Uri.parse(
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=AIzaSyBRtf8M-zYgPr9sTX6Fy3JWoml6FQne5Jc&language=ja'));

    // placeResのbodyに含まれるJSONデータを解析し、Map<String, dynamic>型のplaceDataに格納
    final Map<String, dynamic> placeData = jsonDecode(placeRes.body);

    //画像がなかった場合の処理
    if (placeData["result"] == null ||
        placeData["result"]["photos"] == null ||
        placeData["result"]["photos"].isEmpty) {
      urls.add(
          "https://www.shoshinsha-design.com/wp-content/uploads/2020/05/noimage-760x460.png");
      notifyListeners();
      return;
    }

    final List photos = placeData["result"]["photos"];

    //photosリストから、最初の写真のphoto_referenceを取得
    //写真のリストの先頭だけ取得
    final photo_reference = photos[0]['photo_reference'];
    final url =
        "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=$photo_reference&key=AIzaSyBRtf8M-zYgPr9sTX6Fy3JWoml6FQne5Jc&language=ja";
    urls.add(url);
    notifyListeners();
  }

  Future<void> fetchDetailPhoto(String placeId) async {
    final placeRes = await http.get(Uri.parse(
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=AIzaSyBRtf8M-zYgPr9sTX6Fy3JWoml6FQne5Jc'));
    final Map<String, dynamic> placeData = jsonDecode(placeRes.body);
    if (placeData["result"] == null || placeData["result"]["photos"] == null) {
      bodyUrls.add(
          "https://www.shoshinsha-design.com/wp-content/uploads/2020/05/noimage-760x460.png");
      notifyListeners();
      return;
    }
    final List photos = placeData["result"]["photos"];
    if (photos.isEmpty) {
      bodyUrls.add(
          "https://www.shoshinsha-design.com/wp-content/uploads/2020/05/noimage-760x460.png");
      notifyListeners();
      return;
    }
    for (final photo in photos) {
      final photo_reference = photo['photo_reference'];
      final url =
          "https://maps.googleapis.com/maps/api/place/photo?maxwidth=700&photoreference=$photo_reference&key=AIzaSyBRtf8M-zYgPr9sTX6Fy3JWoml6FQne5Jc";
      bodyUrls.add(url);
    }
    notifyListeners();
  }
}
