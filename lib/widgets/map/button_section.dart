import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../state/providers/map/map_provider.dart';
import '../../view_models/map_view_model.dart';

// class ButtonSection extends ConsumerStatefulWidget {
//   @override
//   ConsumerState<ButtonSection> createState() => _ButtonSectionState();
// }
//
// class _ButtonSectionState extends ConsumerState<ButtonSection> {
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Stack(
//         children: [
//           Container(
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(10), // 角を丸くする
//               color: Colors.grey.withOpacity(0.5), // 透明のグレイ色
//             ),
//             height: MediaQuery.of(context).size.height / 3, // 画面の三分の一の高さ
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               _searchButton(),
//               _moveCurrentPosition(),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   //バスケコート検索ボタン
//   Widget _searchButton() {
//     return ElevatedButton(
//       onPressed: () async {
//         LatLng center = await MapViewModel().getMiddlePoint(context, ref);
//         await MapViewModel()
//             .setMarkers(center.latitude, center.longitude, context, ref);
//       },
//       style: ElevatedButton.styleFrom(
//         backgroundColor: Colors.indigo[900],
//         elevation: 6.0,
//       ),
//       child: const Padding(
//         padding: EdgeInsets.all(8.0),
//         child: Text(
//           'このエリアを検索する',
//           style: TextStyle(fontSize: 20.0, color: Colors.white),
//         ),
//       ),
//     );
//   }
//
// //現在位置にカメラ移動
//   Widget _moveCurrentPosition() {
//     final mapStateNotifier = ref.read(mapProvider);
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: ElevatedButton(
//         onPressed: () {
//           if (mapStateNotifier.currentPosition != null) {
//             mapStateNotifier.mapController!.animateCamera(
//               CameraUpdate.newLatLng(
//                 LatLng(mapStateNotifier.currentPosition!.latitude,
//                     mapStateNotifier.currentPosition!.longitude),
//               ),
//             );
//           }
//         },
//         style: ElevatedButton.styleFrom(
//           shape: const CircleBorder(), // 円形のボタンにする
//           padding: const EdgeInsets.all(15), // アイコンとボタンの間のパディングを調整する
//           backgroundColor: Colors.indigo[900], // ボタンの背景色を設定する
//         ),
//         child: const Icon(
//           Icons.location_on,
//           size: 30,
//           color: Colors.white,
//         ), // ボタンに表示するアイコン
//       ),
//     );
//   }
// }

class ButtonSection extends ConsumerWidget {
  const ButtonSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapStateNotifier = ref.watch(mapProvider);
    return mapStateNotifier.loadMap
        ? Padding(
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
                    _searchButton(context, ref),
                    _moveCurrentPosition(ref),
                  ],
                ),
              ],
            ),
          )
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), // 角を丸くする
                color: Colors.grey.withOpacity(0.5), // 透明のグレイ色
              ),
              height: MediaQuery.of(context).size.height / 3, // 画面の三分の一の高さ
            ),
          );
  }

  Widget _searchButton(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () async {
        LatLng center = await MapViewModel().getMiddlePoint(context, ref);
        await MapViewModel()
            .setMarkers(center.latitude, center.longitude, context, ref);
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
  Widget _moveCurrentPosition(WidgetRef ref) {
    final mapStateNotifier = ref.read(mapProvider);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () {
          if (mapStateNotifier.currentPosition != null) {
            mapStateNotifier.mapController!.animateCamera(
              CameraUpdate.newLatLng(
                LatLng(mapStateNotifier.currentPosition!.latitude,
                    mapStateNotifier.currentPosition!.longitude),
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
