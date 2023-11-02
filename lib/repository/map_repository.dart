import 'dart:convert' as convert;
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../map_api_key.dart';
import '../models/locations.dart';
import '../providers/map_provider.dart';

class MapRepository {
  //バスケットコートのデータを取得
  Future<Locations?> getCourt(
    double latitude,
    double longitude,
  ) async {
    const getCourtURL =
        'https://maps.googleapis.com/maps/api/place/textsearch/json?query=バスケットコート&key=$apiKey&language=ja';

    try {
      final response = await http
          .get(Uri.parse('$getCourtURL&location=$latitude,$longitude'));
      if (response.statusCode == 200) {
        return Locations.fromJson(convert.json.decode(response.body));
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  //placeIdを使用して詳細な場所情報を取得し、先頭の写真データだけを取得
  Future<void> fetchPhoto(String placeId, context) async {
    final mapProvider = Provider.of<MapProvider>(context, listen: false);

    //Google Maps Places APIの詳細情報を取得
    // placeRes --> APIからのレスポンス
    final placeRes = await http.get(Uri.parse(
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$apiKey&language=ja'));

    // placeResのbodyに含まれるJSONデータを解析し、Map<String, dynamic>型のplaceDataに格納
    final Map<String, dynamic> placeData = jsonDecode(placeRes.body);

    //画像がなかった場合の処理
    if (placeData["result"] == null ||
        placeData["result"]["photos"] == null ||
        placeData["result"]["photos"].isEmpty) {
      mapProvider.addUrls(
          "https://www.shoshinsha-design.com/wp-content/uploads/2020/05/noimage-760x460.png");
      return;
    }

    final List photos = placeData["result"]["photos"];

    //photosリストから、最初の写真のphoto_referenceを取得
    //写真のリストの先頭だけ取得
    final photoReference = photos[0]['photo_reference'];
    final url =
        "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=$photoReference&key=$apiKey&language=ja";
    // _urls.add(url);
    mapProvider.addUrls(url);
  }

  //placeIdを使用して詳細な場所情報を取得し、写真データを取得
  Future<void> fetchDetailPhoto(String placeId, context) async {
    final mapProvider = Provider.of<MapProvider>(context, listen: false);

    final placeRes = await http.get(Uri.parse(
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$apiKey'));
    final Map<String, dynamic> placeData = jsonDecode(placeRes.body);
    if (placeData["result"] == null || placeData["result"]["photos"] == null) {
      mapProvider.addBodyUrl(
          "https://www.shoshinsha-design.com/wp-content/uploads/2020/05/noimage-760x460.png");
      return;
    }
    final List photos = placeData["result"]["photos"];
    if (photos.isEmpty) {
      mapProvider.addBodyUrl(
          "https://www.shoshinsha-design.com/wp-content/uploads/2020/05/noimage-760x460.png");

      return;
    }
    for (final photo in photos) {
      final photoReference = photo['photo_reference'];
      final url =
          "https://maps.googleapis.com/maps/api/place/photo?maxwidth=700&photoreference=$photoReference&key=$apiKey";
      mapProvider.addBodyUrl(url);
    }
  }
}
