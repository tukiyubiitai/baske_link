import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/map/map_model.dart';
import '../../repository/map_repository.dart';
import '../dialogs/snackbar_utils.dart';
import '../state/providers/map/map_provider.dart';

//ViewModelはビュー（MapPage）に表示されるデータを管理し、
// Modelからデータを取得します。
class MapViewModel extends ChangeNotifier {
  final MapModel model = MapModel();
  Position? currentPosition;

  //現在地を取得する
  Future<void> getCurrentLocation(BuildContext context, WidgetRef ref) async {
    // final mapProvider = Provider.of<MapProvider>(context, listen: false);
    final mapStateNotifier = ref.read(mapProvider);
    try {
      //mapModelから現在位置が返ってくる
      currentPosition = await model.getCurrentLocation();
      mapStateNotifier.addCurrentPosition(currentPosition as Position);
      if (mapStateNotifier.mapController != null) {
        final zoomLevel = await mapStateNotifier.mapController!.getZoomLevel();
        //現在地の座標までカメラを移動
        mapStateNotifier.mapController!.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(mapStateNotifier.currentPosition!.latitude,
                  mapStateNotifier.currentPosition!.longitude),
              zoom: zoomLevel,
            ),
          ),
        );
      }
    } catch (e) {
      print(e);
      showErrorSnackBar(
        context: context,
        text: e.toString(),
      );
    }
  }

  //画面の中央の座標を取得する
  Future<LatLng> getMiddlePoint(BuildContext context, WidgetRef ref) async {
    // final mapProvider = Provider.of<MapProvider>(context, listen: false);
    final mapStateNotifier = ref.read(mapProvider);
    double screenWidth = MediaQuery.of(context).size.width *
        MediaQuery.of(context).devicePixelRatio;
    double screenHeight = MediaQuery.of(context).size.height *
        MediaQuery.of(context).devicePixelRatio;

    double middleX = screenWidth / 2;
    double middleY = screenHeight / 2;

    ScreenCoordinate screenCoordinate =
        ScreenCoordinate(x: middleX.round(), y: middleY.round());
    LatLng middlePoint =
        await mapStateNotifier.mapController!.getLatLng(screenCoordinate);

    return middlePoint;
  }

  //現在位置から近くのバスケコートのマーカーを表示する
  Future<void> setMarkers(double? latitude, double? longitude,
      BuildContext context, WidgetRef ref) async {
    final mapStateNotifier = ref.read(mapProvider);

    if (latitude == null || longitude == null) {
      mapStateNotifier.clearMakers(); //座標がnullの場合はMakersをクリアする
      return;
    }

    try {
      mapStateNotifier.setLoading(true); //ロード開始
      //バスケコートの座標
      final locations = await MapRepository().getCourt(latitude, longitude);

      if (locations == null || locations.results.isEmpty) {
        mapStateNotifier.setLoading(false);

        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('エラー'),
              content: const Text('バスケコートが見つかりませんでした'),
              actions: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("OK"),
                ),
              ],
            );
          },
        );
      }
      //map上のマーカーのアイコン
      BitmapDescriptor markerBitMap = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(),
        "assets/images/basketball.png",
      );

      // マーカーを保持するMapを初期化
      mapStateNotifier.clearMakers();
      // マーカーに関するUrlsを初期化
      mapStateNotifier.clearUrls();

      // マーカー処理前に locations が null でないことを確認
      if (locations != null) {
        // locations!.resultsをcourtに入れていく
        for (final court in locations.results) {
          //コートの画像を取得する
          await MapRepository().fetchPhoto(court.place_id, context, ref);
          //markerにバスケコートの情報を入れる
          final marker = Marker(
            markerId: MarkerId(court.place_id),
            position: LatLng(court.lat, court.lng),
            infoWindow: InfoWindow(
              title: court.name,
            ),
            icon: markerBitMap,
            onTap: () {
              final markerId = MarkerId(court.place_id).toString();
              final index =
                  mapStateNotifier.markers.keys.toList().indexOf(markerId);
              mapStateNotifier.selectIndex(index);
            },
          );
          mapStateNotifier.addMaker(
              MarkerId(court.place_id).toString(), marker);
          mapStateNotifier.addAddress(court.formatted_address);
        }
      }
    } catch (e) {
      showErrorSnackBar(
        context: context,
        text: "バスケットコート情報の取得中にエラーが発生しました: $e",
      );
      // エラー処理を追加
    } finally {
      //ロード完了
      mapStateNotifier.setLoading(false);
    }
  }

  //バスケコートの情報をシェアする時に呼ばれる
  Future<void> shareImage(String imageUrl, String title) async {
    try {
      final uri = Uri.parse(imageUrl);
      final response = await http.get(uri);
      await Share.shareXFiles(
        [
          XFile.fromData(
            response.bodyBytes,
            name: title,
            mimeType: "image/png",
          ),
        ],
        subject: title,
      );
    } catch (e) {}
  }

  //googleMapで選択された現在地からバスケットコートまでの道のりを表示
  Future getUrl(double courtPositionLatitude, double courtPositionLongitude,
      BuildContext context, WidgetRef ref) async {
    // final mapProvider = Provider.of<MapProvider>(context, listen: false);
    final mapStateNotifier = ref.read(mapProvider);

    currentPosition = await model.getCurrentLocation();

    final currentLatitude = currentPosition!.latitude;
    final currentLongitude = currentPosition!.longitude;

    String urlString = "";
    if (Platform.isAndroid) {
      urlString =
          "https://www.google.co.jp/maps/dir/$currentLatitude,$currentLongitude/$courtPositionLatitude,$courtPositionLongitude";
    } else if (Platform.isIOS) {
      urlString =
          "comgooglemaps://?saddr=$currentLatitude,$currentLongitude&daddr=$courtPositionLatitude,$courtPositionLongitude&directionsmode=walking";
    }
    mapStateNotifier.addMapUrl = Uri.parse(urlString);
    // mapURL = Uri.parse(urlString);
  }

  //バスケットコートの情報をgoogleMapで確認する際に呼ばれる
  Future<void> handleUrlAction(
      double courtPositionLatitude,
      double courtPositionLongitude,
      BuildContext context,
      WidgetRef ref) async {
    // final mapProvider = Provider.of<MapProvider>(context, listen: false);
    final mapStateNotifier = ref.read(mapProvider);

    try {
      await getUrl(courtPositionLatitude, courtPositionLatitude, context, ref);
      if (mapStateNotifier.mapURL != null) {
        launchUrl(mapStateNotifier.mapURL!);
      }
    } catch (e) {
      showSnackBar(
        context: context,
        text: "エラー",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }
}
