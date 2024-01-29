import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../dialogs/snackbar_utils.dart';
import '../../state/providers/map/map_provider.dart';
import '../../view_models/map_view_model.dart';
import '../../widgets/map/button_section.dart';
import '../../widgets/map/list_section.dart';

class MapPage extends ConsumerStatefulWidget {
  const MapPage({super.key});

  @override
  ConsumerState<MapPage> createState() => MapPageState();
}

class MapPageState extends ConsumerState<MapPage> {
  final MapViewModel viewModel = MapViewModel();
  late GoogleMapController _controller;

  @override
  void initState() {
    super.initState();
    _loadCurrentLocation();
    //位置情報が許可されていない時に許可をリクエストする
  }

  //位置情報の許可をリクエストする
  Future<void> _loadCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      await Geolocator.requestPermission();
    }
    await viewModel.getCurrentLocation(context, ref);
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
          _buildMapSection(),
          ButtonSection(),
          ListSection(),
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
    final mapStateNotifier = ref.watch(mapProvider);
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: _kGooglePlex,
      myLocationEnabled: true,
      onMapCreated: _onMapCreated,
      markers: mapStateNotifier.markers.values.toSet(),
      onTap: (_) => viewModel.getMiddlePoint(context, ref),
    );
  }

  //最初にマップが作成される時に呼ばれる
  Future<void> _onMapCreated(GoogleMapController controller) async {
    final mapStateNotifier = ref.read(mapProvider);
    //選択されたcourt番号をnullにもどす
    mapStateNotifier.clearSelect();

    _controller = controller;
    mapStateNotifier.addMapController(_controller);
    if (mapStateNotifier.currentPosition != null) {
      try {
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

        await viewModel.setMarkers(mapStateNotifier.currentPosition!.latitude,
            mapStateNotifier.currentPosition!.longitude, context, ref);
      } catch (e) {
        showErrorSnackBar(
          context: context,
          text: "バスケットコート情報の取得中にエラーが発生しました: $e",
        );
      }
    }
    //map読み込み完了を通知
    mapStateNotifier.setLoadMap(true);
  }
}
