import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/map_model.dart';
import '../providers/map_provider.dart';
import '../widgets/common_widgets/snackbar_utils.dart';
import 'map_repository.dart';

//ViewModelはビュー（MapPage）に表示されるデータを管理し、
// Modelからデータを取得します。
class MapViewModel {
  final MapModel model = MapModel();
  Position? currentPosition;

  //現在地を取得する
  Future<void> getCurrentLocation(context) async {
    final mapProvider = Provider.of<MapProvider>(context, listen: false);
    try {
      //mapModelから現在位置が返ってくる
      currentPosition = await model.getCurrentLocation();
      mapProvider.addCurrentPosition(currentPosition as Position);
      final zoomLevel = await mapProvider.mapController!.getZoomLevel();
      //現在地の座標までカメラを移動
      mapProvider.mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(mapProvider.currentPosition!.latitude,
                mapProvider.currentPosition!.longitude),
            zoom: zoomLevel,
          ),
        ),
      );
    } catch (e) {
      showErrorSnackBar(
        context: context,
        text: e.toString(),
      );
    }
  }

  //画面の中央の座標を取得する
  Future<LatLng> getMiddlePoint(context) async {
    final mapProvider = Provider.of<MapProvider>(context, listen: false);

    double screenWidth = MediaQuery.of(context).size.width *
        MediaQuery.of(context).devicePixelRatio;
    double screenHeight = MediaQuery.of(context).size.height *
        MediaQuery.of(context).devicePixelRatio;

    double middleX = screenWidth / 2;
    double middleY = screenHeight / 2;

    ScreenCoordinate screenCoordinate =
        ScreenCoordinate(x: middleX.round(), y: middleY.round());
    LatLng middlePoint =
        await mapProvider.mapController!.getLatLng(screenCoordinate);

    return middlePoint;
  }

  //現在位置から近くのバスケコートのマーカーを表示する
  Future<void> setMarkers(double? latitude, double? longitude, context) async {
    final mapProvider = Provider.of<MapProvider>(context, listen: false);

    if (latitude == null || longitude == null) {
      mapProvider.clearMakers(); //座標がnullの場合はMakersをクリアする
      return;
    }

    try {
      //バスケコートの座標
      final locations = await MapRepository().getCourt(latitude, longitude);

      if (locations == null || locations.results.isEmpty) {
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
      mapProvider.clearMakers();
      // マーカーに関するUrlsを初期化
      mapProvider.clearUrls();

      // マーカー処理前に locations が null でないことを確認
      if (locations != null) {
        // locations!.resultsをcourtに入れていく
        for (final court in locations.results) {
          //コートの画像を取得する
          await MapRepository().fetchPhoto(court.place_id, context);
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
              final index = mapProvider.markers.keys.toList().indexOf(markerId);
              mapProvider.selectIndex(index);
            },
          );
          mapProvider.addMaker(MarkerId(court.place_id).toString(), marker);
          mapProvider.addAddress(court.formatted_address);
        }
        mapProvider.setLoadMarkers(true); //処理完了を通知
      }
    } catch (e) {
      showErrorSnackBar(
        context: context,
        text: "バスケットコート情報の取得中にエラーが発生しました: $e",
      );
      // エラー処理を追加
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
      context) async {
    final mapProvider = Provider.of<MapProvider>(context, listen: false);

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
    mapProvider.addMapUrl = Uri.parse(urlString);
    // mapURL = Uri.parse(urlString);
  }

  //バスケットコートの情報をgoogleMapで確認する際に呼ばれる
  Future<void> handleUrlAction(double courtPositionLatitude,
      double courtPositionLongitude, BuildContext context) async {
    final mapProvider = Provider.of<MapProvider>(context, listen: false);

    try {
      await getUrl(courtPositionLatitude, courtPositionLatitude, context);
      if (mapProvider.mapURL != null) {
        launchUrl(mapProvider.mapURL!);
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
