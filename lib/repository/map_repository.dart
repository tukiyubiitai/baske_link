import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../state/providers/locations.dart';
import '../state/providers/map/map_provider.dart';
import '../utils/error_handler.dart';
import '../utils/logger.dart';
import '../utils/map_api_key.dart';

class MapRepository {
  // デフォルトの画像URL。画像が見つからない場合に使用されます。
  static const String defaultImageUrl =
      "https://www.shoshinsha-design.com/wp-content/uploads/2020/05/noimage-760x460.png";

  /// Google Places APIを使用して、指定された座標周辺のバスケットコート情報を取得します。
  /// [latitude]と[longitude]で位置を指定します。
  Future<Locations?> getCourt(double latitude, double longitude) async {
    // APIのエンドポイントURL
    const getCourtURL =
        'https://maps.googleapis.com/maps/api/place/textsearch/json?query=バスケットコート&key=$apiKey&language=ja';

    try {
      final response = await http
          .get(Uri.parse('$getCourtURL&location=$latitude,$longitude'));
      // ステータスコードが200（成功）の場合、取得したデータを解析して返します。
      if (response.statusCode == 200) {
        return Locations.fromJson(json.decode(response.body));
      } else {
        // ステータスコードに応じたエラーメッセージをログに記録します。
        String errorMessage =
            HttpStatusErrorMessage.getMessage(response.statusCode);
        AppLogger.instance.error("APIエラー: $errorMessage");
      }
    } catch (e) {
      // HTTPリクエストの例外をキャッチしてログに記録します。
      AppLogger.instance.error("APIエラー $e");
    }
    return null;
  }

  /// 指定されたURLから場所の詳細情報を取得します。
  Future<Map<String, dynamic>?> fetchPlaceDetails(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        // 正常にデータが取得できた場合、JSONを解析して返します。
        return json.decode(response.body);
      } else {
        // ステータスコードに応じたエラーメッセージをログに記録します。
        String errorMessage =
            HttpStatusErrorMessage.getMessage(response.statusCode);
        AppLogger.instance.error("APIエラー: $errorMessage");
      }
    } catch (e) {
      // HTTPリクエストの例外をキャッチしてログに記録します。
      AppLogger.instance.error("URL所得エラー $e");
    }
    return null;
  }

  /// 指定された場所IDに基づいて、最大幅[maxWidth]の写真URLを取得し、
  /// 状態管理オブジェクトに追加します。
  Future<void> fetchPhotos(String placeId, WidgetRef ref,
      {int maxWidth = 400}) async {
    final url =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$apiKey&language=ja';
    final placeData = await fetchPlaceDetails(url);
    if (placeData == null) return; // エラー処理

    final photos = placeData["result"]["photos"];
    if (photos == null || photos.isEmpty) {
      // 写真がない場合はデフォルト画像URLを使用します。
      ref.read(mapProvider).addUrls(defaultImageUrl);
      return;
    }

    // 写真のURLを構築し、状態管理オブジェクトに追加します。
    for (final photo in photos) {
      final photoReference = photo['photo_reference'];
      final photoUrl =
          "https://maps.googleapis.com/maps/api/place/photo?maxwidth=$maxWidth&photoreference=$photoReference&key=$apiKey&language=ja";
      ref.read(mapProvider).addUrls(photoUrl);
    }
  }

  /// 指定された場所IDから詳細な写真を取得し、状態管理オブジェクトに追加します。
  Future<void> fetchDetailPhoto(String placeId, WidgetRef ref) async {
    final mapStateNotifier = ref.read(mapProvider);

    // URLの組み立て
    final url =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$apiKey';
    final placeData = await fetchPlaceDetails(url);
    if (placeData == null) return; // エラー処理
    if (placeData["result"] == null || placeData["result"]["photos"] == null) {
      mapStateNotifier.addBodyUrl(defaultImageUrl);
      return;
    }
    final List photos = placeData["result"]["photos"];
    if (photos.isEmpty) {
      mapStateNotifier.addBodyUrl(defaultImageUrl);
      return;
    }
    // 写真のURLを構築し、追加します。
    for (final photo in photos) {
      final photoReference = photo['photo_reference'];
      final url =
          "https://maps.googleapis.com/maps/api/place/photo?maxwidth=700&photoreference=$photoReference&key=$apiKey";
      mapStateNotifier.addBodyUrl(url);
    }
  }
}

//placeIdを使用して詳細な場所情報を取得し、先頭の写真データだけを取得
// Future<void> fetchPhoto(String placeId, WidgetRef ref) async {
//   final mapStateNotifier = ref.read(mapProvider);
//
//   //Google Maps Places APIの詳細情報を取得
//   // placeRes --> APIからのレスポンス
//   final placeRes = await http.get(Uri.parse(
//       'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$apiKey&language=ja'));
//
//   // placeResのbodyに含まれるJSONデータを解析し、Map<String, dynamic>型のplaceDataに格納
//   final Map<String, dynamic> placeData = jsonDecode(placeRes.body);
//
//   //画像がなかった場合の処理
//   if (placeData["result"] == null ||
//       placeData["result"]["photos"] == null ||
//       placeData["result"]["photos"].isEmpty) {
//     mapStateNotifier.addUrls(
//         "https://www.shoshinsha-design.com/wp-content/uploads/2020/05/noimage-760x460.png");
//     return;
//   }
//
//   final List photos = placeData["result"]["photos"];
//
//   //photosリストから、最初の写真のphoto_referenceを取得
//   //写真のリストの先頭だけ取得
//   final photoReference = photos[0]['photo_reference'];
//   final url =
//       "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=$photoReference&key=$apiKey&language=ja";
//   mapStateNotifier.addUrls(url);
// }

//placeIdを使用して詳細な場所情報を取得し、写真データを取得
// Future<void> fetchDetailPhoto(String placeId, WidgetRef ref) async {
//   final mapStateNotifier = ref.read(mapProvider);
//
//   final placeRes = await http.get(Uri.parse(
//       'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$apiKey'));
//   final Map<String, dynamic> placeData = jsonDecode(placeRes.body);
//   if (placeData["result"] == null || placeData["result"]["photos"] == null) {
//     mapStateNotifier.addBodyUrl(
//         "https://www.shoshinsha-design.com/wp-content/uploads/2020/05/noimage-760x460.png");
//     return;
//   }
//   final List photos = placeData["result"]["photos"];
//   if (photos.isEmpty) {
//     mapStateNotifier.addBodyUrl(
//         "https://www.shoshinsha-design.com/wp-content/uploads/2020/05/noimage-760x460.png");
//
//     return;
//   }
//   for (final photo in photos) {
//     final photoReference = photo['photo_reference'];
//     final url =
//         "https://maps.googleapis.com/maps/api/place/photo?maxwidth=700&photoreference=$photoReference&key=$apiKey";
//     mapStateNotifier.addBodyUrl(url);
//   }
// }
