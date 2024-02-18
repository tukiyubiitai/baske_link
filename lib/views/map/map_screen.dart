import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../state/providers/providers.dart';
import '../../widgets/map/build_map_section.dart';
import '../../widgets/map/button_section.dart';
import '../../widgets/map/list_section.dart';

class MapPage extends ConsumerStatefulWidget {
  const MapPage({super.key});

  @override
  ConsumerState<MapPage> createState() => MapPageState();
}

class MapPageState extends ConsumerState<MapPage> {
  @override
  void initState() {
    super.initState();
    //位置情報が許可されていない時に許可をリクエストする
    //現在地を取得
    ref.read(mapViewModelProvider).loadCurrentLocation(ref);
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(mapViewModelProvider);
    final errorMessage = ref.watch(errorMessageProvider); //エラーを監視

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          BuildMapSection(), //GoogleMap
          ButtonSection(), //検索ボタン、現在地ボタン
          ListSection(), //カード
        ],
      ),
    );
  }
}
