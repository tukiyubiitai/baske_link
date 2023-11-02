import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../providers/map_provider.dart';
import '../../repository/map_repository.dart';
import '../../repository/map_view_model.dart';
import '../common_widgets/snackbar_utils.dart';

class ListSection extends StatefulWidget {
  const ListSection({super.key});

  @override
  State<ListSection> createState() => _ListSectionState();
}

class _ListSectionState extends State<ListSection> {
  late int _currentIndex;
  late PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();

    _currentIndex = 0; // PageView の初期表示ページを設定

    // PageViewの表示を切り替えるのに使う
    _pageController = PageController(
        initialPage: _currentIndex,
        viewportFraction: 0.85); //0.85くらいで端っこに別のカードが見えてる感じになる
  }

  @override
  Widget build(BuildContext context) {
    final mapProvider = Provider.of<MapProvider>(context, listen: false);

    //マーカーがタップされた時に、その番号に該当するPageViewまでスクロールする
    Future<void> scrollToSelectedPage(int selectedPage) async {
      await _pageController.animateToPage(
        selectedPage,
        duration: const Duration(milliseconds: 1),
        curve: Curves.linear,
      );
    }

    final int? selectIndex = mapProvider.selectCourt; //タップされたマーカーの番号が入る
    if (selectIndex != null) {
      if (_pageController.hasClients) {
        //その番号に該当するPageViewまでスクロールする
        scrollToSelectedPage(selectIndex);
      }
    }

    return Container(
      height: 148,
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
      child: PageView(
        onPageChanged: (int index) async {
          final zoomLevel = await mapProvider.mapController!.getZoomLevel();
          final selectedCourt = selectIndex != null
              ? mapProvider.markers.values
                  .elementAt(selectIndex) //マーカーがタップされた時の処理
              : mapProvider.markers.values
                  .elementAt(index); //PageViewがスワップされた通常時の処理
          mapProvider
              .clearSelect(); //mapProvider.selectCourt(タップされたマーカーの番号)をnullに戻す

          //スワイプ後のcourtの座標までカメラを移動
          mapProvider.mapController!.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: LatLng(selectedCourt.position.latitude,
                    selectedCourt.position.longitude),
                zoom: zoomLevel,
              ),
            ),
          );
          final mapController = mapProvider.mapController;
          if (mapController != null) {
            //mapにマーカーを表示させる

            await mapController.showMarkerInfoWindow(selectedCourt.markerId);
          }
        },
        controller: _pageController,
        children: _buildCourtCard(), // ページビュー内のカードウィジェットを生成
      ),
    );
  }

  List<Widget> _buildCourtCard() {
    final mapProvider = Provider.of<MapProvider>(context, listen: false);
    return List.generate(
      mapProvider.markers.length, //取得したマーカーの数
      (index) {
        final marker = mapProvider.markers.values.toList()[index];
        final imageUrl = mapProvider.urls[index].toString();
        final courtAddress = mapProvider.addressList[index];
        double? courtPositionLatitude;
        double? courtPositionLongitude;
        // カードウィジェットを生成
        return Card(
          child: SizedBox(
            height: 100,
            child: Row(
              children: [
                // 画像の表示部分
                SizedBox(
                  width: 120,
                  height: 120,
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
                Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        // タイトルテキストの表示
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            marker.infoWindow.title.toString(),
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 3,
                            softWrap: true,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          // 詳細ボタンがタップされた時の処理
                          mapProvider.clearBodyUrls();
                          final tappedMarker = marker;
                          final placeId = tappedMarker.markerId.value;
                          await MapRepository()
                              .fetchDetailPhoto(placeId, context);
                          showModalBottomSheet(
                            context: context,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(25.0),
                              ),
                            ),
                            builder: (BuildContext context) {
                              return SizedBox(
                                width: double.infinity,
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      child: Text(
                                        marker.infoWindow.title.toString(),
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 3,
                                        softWrap: true,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        // シェアボタン
                                        _buildIconButtonWithText(
                                          Icons.share,
                                          "シェアする",
                                          () async {
                                            await MapViewModel().shareImage(
                                                imageUrl,
                                                marker.infoWindow.title
                                                    .toString());
                                          },
                                        ),
                                        // Googleマップで開くボタン
                                        _buildIconButtonWithText(
                                          Icons.navigation,
                                          "google mapで開く",
                                          () async {
                                            await MapViewModel()
                                                .handleUrlAction(
                                                    courtPositionLatitude!,
                                                    courtPositionLongitude!,
                                                    context);
                                          },
                                        ),
                                        // お気に入りボタン
                                        _buildIconButtonWithText(
                                          Icons.favorite,
                                          "お気に入り",
                                          () {
                                            Navigator.of(context).pop();
                                            showSnackBar(
                                              context: context,
                                              text: 'ごめんなさい。その機能は開発中です(T . T)',
                                              backgroundColor: Colors.indigo,
                                              textColor: Colors.white,
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    // コートの場所の住所
                                    _buildCourtLocation(courtAddress),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    // コートの写真を表示
                                    _buildPhotoPageView(context),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.orange),
                        ),
                        child: const Text("詳細"),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // アイコンとテキストを含むボタンウィジェットを生成
  Widget _buildIconButtonWithText(
      IconData icon, String text, VoidCallback onPressed) {
    return Column(
      children: [
        IconButton(
          onPressed: onPressed,
          icon: Icon(
            icon,
            color: Colors.blue,
          ),
        ),
        Text(
          text,
          style: const TextStyle(color: Colors.blue),
        ),
      ],
    );
  }

  // コートの場所情報ウィジェットを生成
  Widget _buildCourtLocation(String courtAddress) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          width: 0.5,
        ),
      ),
      child: ListTile(
        leading: const Icon(Icons.map, color: Colors.blue, size: 25),
        title: Text(
          courtAddress
              .replaceFirst("日本、〒", "")
              .replaceAll(RegExp(r'\d{3}-\d{4}'), ''),
          style: const TextStyle(fontSize: 14),
        ),
      ),
    );
  }

  // 写真のページビューウィジェットを生成
  Widget _buildPhotoPageView(BuildContext context) {
    final mapProvider = Provider.of<MapProvider>(context, listen: false);
    return Expanded(
      child: Container(
        child: PageView.builder(
          controller: PageController(viewportFraction: 0.6),
          itemCount: mapProvider.bodyUrls.length,
          itemBuilder: (BuildContext context, int index) {
            final image = mapProvider.bodyUrls[index];
            return Container(
              padding: const EdgeInsets.all(9),
              child: _photoItem(image),
            );
          },
        ),
      ),
    );
  }

// 写真ウィジェットを生成
  Widget _photoItem(String image) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: Image.network(
        image,
        fit: BoxFit.cover,
      ),
    );
  }
}
