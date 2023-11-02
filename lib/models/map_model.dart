import 'package:geolocator/geolocator.dart';

//Modelはアプリケーションのビジネスロジックとデータ処理を担当します。
// MapPageの位置情報取得の部分をModelに移動しましょう。
class MapModel {
  Future<Position?> getCurrentLocation() async {
    try {
      Position? position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      return position;
    } catch (e) {
      throw Exception("位置情報の取得に失敗しました: $e");
    }
  }
}
