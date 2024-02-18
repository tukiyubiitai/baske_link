import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../state/providers/locations.dart';
import '../state/providers/map/map_provider.dart';
import '../utils/error_handler.dart';
import '../utils/logger.dart';

class MapRepository {
  final String apiKey = dotenv.env['apiKey'].toString();

  // デフォルトの画像URL。画像が見つからない場合に使用されます。
  static const String defaultImageUrl =
      "https://www.shoshinsha-design.com/wp-content/uploads/2020/05/noimage-760x460.png";

  /// Google Places APIを使用して、指定された座標周辺のバスケットコート情報を取得します。
  /// [latitude]と[longitude]で位置を指定します。
  Future<Locations?> getCourt(double latitude, double longitude) async {
    // APIのエンドポイントURL
    final getCourtURL =
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
            HttpStatusErrorMessage.getHttpMessage(response.statusCode);
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
            HttpStatusErrorMessage.getHttpMessage(response.statusCode);
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
