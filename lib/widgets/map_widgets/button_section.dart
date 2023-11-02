import 'package:basketball_app/repository/map_view_model.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../providers/map_provider.dart';

class ButtonSection extends StatefulWidget {
  @override
  State<ButtonSection> createState() => _ButtonSectionState();
}

class _ButtonSectionState extends State<ButtonSection> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), // 角を丸くする
              color: Colors.grey.withOpacity(0.5), // 透明のグレイ色
            ),
            height: MediaQuery.of(context).size.height / 3, // 画面の三分の一の高さ
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _searchButton(),
              _moveCurrentPosition(),
            ],
          ),
        ],
      ),
    );
  }

  //バスケコート検索ボタン
  Widget _searchButton() {
    return ElevatedButton(
      onPressed: () async {
        LatLng center = await MapViewModel().getMiddlePoint(context);
        await MapViewModel()
            .setMarkers(center.latitude, center.longitude, context);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.indigo[900],
        elevation: 6.0,
      ),
      child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(
          'このエリアを検索する',
          style: TextStyle(fontSize: 20.0, color: Colors.white),
        ),
      ),
    );
  }

//現在位置にカメラ移動
  Widget _moveCurrentPosition() {
    final mapProvider = Provider.of<MapProvider>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () {
          if (mapProvider.currentPosition != null) {
            mapProvider.mapController!.animateCamera(
              CameraUpdate.newLatLng(
                LatLng(mapProvider.currentPosition!.latitude,
                    mapProvider.currentPosition!.longitude),
              ),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(), // 円形のボタンにする
          padding: const EdgeInsets.all(15), // アイコンとボタンの間のパディングを調整する
          backgroundColor: Colors.indigo[900], // ボタンの背景色を設定する
        ),
        child: const Icon(
          Icons.location_on,
          size: 30,
          color: Colors.white,
        ), // ボタンに表示するアイコン
      ),
    );
  }
}
