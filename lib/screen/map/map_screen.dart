import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../providers/map_provider.dart';
import '../../repository/map_view_model.dart';
import '../../widgets/common_widgets/snackbar_utils.dart';
import '../../widgets/map_widgets/button_section.dart';
import '../../widgets/map_widgets/list_section.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
  final MapViewModel viewModel = MapViewModel();
  late GoogleMapController _controller;

  @override
  void initState() {
    super.initState();

    //位置情報が許可されていない時に許可をリクエストする
    Future(() async {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        await Geolocator.requestPermission();
      }
      await viewModel.getCurrentLocation(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // ...AppBarの設定
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Consumer<MapProvider>(builder: (context, model, child) {
            return _buildMapSection();
          }),
          ButtonSection(),
          Consumer<MapProvider>(builder: (context, model, child) {
            if (model.loadMarkers) {
              //マーカー表示の処理が終わったら表示
              return const ListSection();
            } else {
              return const SizedBox();
            }
          }),
          // TestPage(),
        ],
      ),
    );
  }

  //初期位置
  final CameraPosition _kGooglePlex = const CameraPosition(
    target: LatLng(43.0686606, 141.3485613),
    zoom: 15,
  );

  Widget _buildMapSection() {
    final mapProvider = Provider.of<MapProvider>(context, listen: false);
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: _kGooglePlex,
      myLocationEnabled: true,
      onMapCreated: _onMapCreated,
      markers: mapProvider.markers.values.toSet(),
      onTap: (_) => MapViewModel().getMiddlePoint(context),
    );
  }

  //最初にマップが作成される時に呼ばれる
  Future<void> _onMapCreated(GoogleMapController controller) async {
    final mapProvider = Provider.of<MapProvider>(context, listen: false);
    //選択されたcourt番号をnullにもどす
    mapProvider.clearSelect();

    _controller = controller;
    mapProvider.addMapController(_controller);
    if (mapProvider.currentPosition != null) {
      try {
        final zoomLevel = await mapProvider.mapController!.getZoomLevel();
        //スワイプ後のcourtの座標までカメラを移動
        mapProvider.mapController!.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(mapProvider.currentPosition!.latitude,
                  mapProvider.currentPosition!.longitude),
              zoom: zoomLevel,
            ),
          ),
        );
        await MapViewModel().setMarkers(mapProvider.currentPosition!.latitude,
            mapProvider.currentPosition!.longitude, context);
      } catch (e) {
        showErrorSnackBar(
          context: context,
          text: "バスケットコート情報の取得中にエラーが発生しました: $e",
        );
      }
    }
  }
}
