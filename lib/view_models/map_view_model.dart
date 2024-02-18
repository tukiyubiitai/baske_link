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
import '../state/providers/map/map_provider.dart';
import '../utils/error_handler.dart';
import '../utils/logger.dart';

//ViewModelはビュー（MapPage）に表示されるデータを管理し、
// Modelからデータを取得します。
class MapViewModel extends ChangeNotifier {
  final MapModel model = MapModel();
  Position? currentPosition;

  //位置情報の許可をリクエストする
  Future<void> loadCurrentLocation(WidgetRef ref) async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      await Geolocator.requestPermission();
    }
    await getCurrentLocation(ref);
  }

  //最初にマップが作成される時に呼ばれる
  Future<void> onMapCreated(
      GoogleMapController controller, WidgetRef ref) async {
    final mapStateNotifier = ref.read(mapProvider);
    //選択されたcourt番号をnullにもどす
    mapStateNotifier.clearSelect();

    mapStateNotifier.addMapController(controller);
    if (mapStateNotifier.currentPosition != null) {
      final zoomLevel = await mapStateNotifier.mapController!.getZoomLevel();
      //スワイプ後のcourtの座標までカメラを移動
      mapStateNotifier.mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(mapStateNotifier.currentPosition!.latitude,
                mapStateNotifier.currentPosition!.longitude),
            zoom: zoomLevel,
          ),
        ),
      );
      // await setMarkers(ref);
    }
    //map読み込み完了を通知
    mapStateNotifier.setLoadMap(true);
  }

  /// 現在地を取得し、マップに反映する。
  /// [context] - 現在のビルドコンテキスト。
  /// [ref] - WidgetRefを使用して、Providerから状態を読み取るために使用。
  Future<void> getCurrentLocation(WidgetRef ref) async {
    final mapStateNotifier = ref.read(mapProvider);
    try {
      //mapModelから現在位置が返ってくる
      currentPosition = await model.getCurrentLocation();
      if (currentPosition != null) {
        mapStateNotifier.addCurrentPosition(currentPosition as Position);
        await animateMapCamera(ref);
      }
    } catch (e) {
      AppLogger.instance.error("現在地の取得に失敗 $e");
      ErrorHandler.instance.setErrorState(ref, getErrorMessage(e));
    }
  }

  /// マップのカメラをアニメーションで移動する。
  /// [ref] - WidgetRefを使用して、Providerから状態を読み取るために使用。
  Future<void> animateMapCamera(WidgetRef ref) async {
    final mapStateNotifier = ref.read(mapProvider);
    if (mapStateNotifier.mapController != null &&
        mapStateNotifier.currentPosition != null) {
      final zoomLevel = await mapStateNotifier.mapController!.getZoomLevel();
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
  }

  //画面の中央の座標を取得する
  Future<LatLng> getMiddlePoint(WidgetRef ref) async {
    try {
      final mapStateNotifier = ref.read(mapProvider);
      double screenWidth = MediaQuery.of(ref.context).size.width *
          MediaQuery.of(ref.context).devicePixelRatio;
      double screenHeight = MediaQuery.of(ref.context).size.height *
          MediaQuery.of(ref.context).devicePixelRatio;

      double middleX = screenWidth / 2;
      double middleY = screenHeight / 2;

      ScreenCoordinate screenCoordinate =
          ScreenCoordinate(x: middleX.round(), y: middleY.round());
      LatLng middlePoint =
          await mapStateNotifier.mapController!.getLatLng(screenCoordinate);

      return middlePoint;
    } catch (e) {
      AppLogger.instance.error("/画面の中央の座標の取得に失敗 $e");
      throw getErrorMessage(e);
    }
  }

  /// 地図上にバスケットコートの位置を示すマーカーを設置するメソッド。
  /// [latitude] と [longitude] で指定された位置に近いバスケットコートを検索し、
  /// それらの位置にマーカーを設置します。
  /// [latitude] または [longitude] が null の場合、既存のマーカーをクリアします。
  /// [ref] - WidgetRefを使用して、Providerから状態を読み取り、更新します。
  Future<void> setMarkers(WidgetRef ref) async {
    final mapStateNotifier = ref.read(mapProvider);
    LatLng center = await getMiddlePoint(ref);

    mapStateNotifier.setLoading(true); // ロード開始

    try {
      final locations =
          await MapRepository().getCourt(center.latitude, center.longitude);

      // バスケコートの情報が取得できない場合
      if (locations == null || locations.results.isEmpty) {
        // showErrorDialog(ref.context, 'バスケコートが見つかりませんでした');
        throw "バスケコートが見つかりませんでした";
      }

      // map上のマーカーのアイコン
      final markerBitMap = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(),
        "assets/images/basketball.png",
      );

      //マーカークリア
      mapStateNotifier.clearMakers();
      //urlクリア
      mapStateNotifier.clearUrls();
      //アドレスリストクリア
      mapStateNotifier.clearAddress();

      // コートの画像を非同期に並列で取得し、マーカーを作成
      await Future.wait(locations.results.map((court) async {
        await MapRepository().fetchPhotos(court.place_id, ref);

        final marker = Marker(
          markerId: MarkerId(court.place_id),
          position: LatLng(court.lat, court.lng),
          infoWindow: InfoWindow(title: court.name),
          icon: markerBitMap,
          onTap: () => handleMarkerTap(court.place_id, ref),
        );
        mapStateNotifier.addMaker(MarkerId(court.place_id).toString(), marker);
        mapStateNotifier.addAddress(court.formatted_address);
      }));
    } catch (e) {
      AppLogger.instance.error("バスケットコート情報の取得中にエラーが発生しました $e");
      ErrorHandler.instance.setErrorState(ref, getErrorMessage(e));
    } finally {
      mapStateNotifier.setLoading(false); // ロード完了
    }
  }

  void moveToCurrentPosition(WidgetRef ref) {
    // 現在位置にカメラを移動するロジック
    final mapStateNotifier = ref.read(mapProvider);
    if (mapStateNotifier.currentPosition != null) {
      mapStateNotifier.mapController!.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(mapStateNotifier.currentPosition!.latitude,
              mapStateNotifier.currentPosition!.longitude),
        ),
      );
    }
  }

  /// マーカーがタップされたときの動作をハンドルするメソッド。
  /// [placeId] - タップされたマーカーの場所ID。
  /// [ref] - WidgetRefを使用して、マーカーに関連する状態を更新します。
  void handleMarkerTap(String placeId, WidgetRef ref) {
    final mapStateNotifier = ref.read(mapProvider);
    final markerId = MarkerId(placeId).toString();
    final index = mapStateNotifier.markers.keys.toList().indexOf(markerId);
    mapStateNotifier.selectIndex(index);
  }

  /// バスケットコートの画像をシェアするメソッド。
  /// [imageUrl] - シェアする画像のURL。
  /// [title] - シェア時に使用するタイトル。
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
    } catch (e) {
      AppLogger.instance.error("バスケコートの情報をシェアにエラーが発生しました $e");
    }
  }

  //googleMapで選択された現在地からバスケットコートまでの道のりを表示
  Future<void> getUrl(double courtPositionLatitude,
      double courtPositionLongitude, WidgetRef ref) async {
    final mapStateNotifier = ref.read(mapProvider);

    currentPosition = await model.getCurrentLocation();
    if (currentPosition != null) {
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
    } else {
      throw "現在地を取得できませんでした";
    }
  }

  //バスケットコートの情報をgoogleMapで確認する際に呼ばれる
  Future<void> handleUrlAction(
      double courtPositionLatitude,
      double courtPositionLongitude,
      BuildContext context,
      WidgetRef ref) async {
    final mapStateNotifier = ref.read(mapProvider);

    try {
      await getUrl(courtPositionLatitude, courtPositionLatitude, ref);
      if (mapStateNotifier.mapURL != null) {
        launchUrl(mapStateNotifier.mapURL!);
      }
    } catch (e) {
      AppLogger.instance.error("バスケットコートの情報を確認できません $e");
    }
  }
}
