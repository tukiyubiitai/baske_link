import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/model/map_model.dart';
import '../repository/map_repository.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  Position? currentPosition; //現在位置
  late GoogleMapController _controller; //google mapが使える
  late StreamSubscription<Position> positionStream; //デバイスの位置情報を取得する
  final MapModel _mapModel = MapModel(); //model
  final Map<String, Marker> _markers = {}; //バスケットコートの情報
  ScrollController _scrollController = ScrollController();
  final List<String> addressList = []; //バスケットコートの住所

  final _pageController = PageController(
    viewportFraction: 0.85, //0.85くらいで端っこに別のカードが見えてる感じになる,
  );

  CameraPosition? cameraPosition;

  //画面の中央の座標
  Future<LatLng> getMiddlePoint() async {
    double screenWidth = MediaQuery.of(context).size.width *
        MediaQuery.of(context).devicePixelRatio;
    double screenHeight = MediaQuery.of(context).size.height *
        MediaQuery.of(context).devicePixelRatio;

    double middleX = screenWidth / 2;
    double middleY = screenHeight / 2;

    ScreenCoordinate screenCoordinate =
        ScreenCoordinate(x: middleX.round(), y: middleY.round());
    LatLng middlePoint = await _controller.getLatLng(screenCoordinate);

    return middlePoint;
  }

  //初期位置
  final CameraPosition _kGooglePlex = const CameraPosition(
    target: LatLng(43.0686606, 141.3485613),
    zoom: 15,
  );

  final LocationSettings locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.high, //正確性:highはAndroid(0-100m),iOS(10m)
    distanceFilter: 100,
  );

  @override
  void initState() {
    super.initState();

    //位置情報が許可されていない時に許可をリクエストする
    Future(() async {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        await Geolocator.requestPermission();
      }
    });

    //現在位置を更新し続ける
    positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position? position) {
      currentPosition = position;
      print(position == null
          ? 'Unknown'
          : '${position.latitude.toString()}, ${position.longitude.toString()}');
    });
  }

  //最初にマップが作成される時に呼ばれる
  Future<void> _onMapCreated(GoogleMapController controller) async {
    _controller = controller;
    if (currentPosition != null) {
      await _setMarkers(currentPosition!.latitude, currentPosition!.longitude);
    }
  }

  //現在位置にカメラ移動
  Widget _moveCurrentPosition() {
    return ElevatedButton(
      onPressed: () {
        if (currentPosition != null) {
          _controller.animateCamera(
            CameraUpdate.newLatLng(
              LatLng(currentPosition!.latitude, currentPosition!.longitude),
            ),
          );
        }
      },
      style: ElevatedButton.styleFrom(
        shape: CircleBorder(), // 円形のボタンにする
        padding: EdgeInsets.all(15), // アイコンとボタンの間のパディングを調整する
        backgroundColor: Colors.blue, // ボタンの背景色を設定する
      ),
      child: Icon(
        Icons.location_on,
        size: 30,
        color: Colors.white,
      ), // ボタンに表示するアイコン
    );
  }

  //下の背景
  Widget _container() {
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

  //エリア検索ボタンがタップされた時の
  void _onMapTapped() async {
    LatLng center = await getMiddlePoint();
    _setMarkers(
      center.latitude,
      center.longitude,
    );
    print(center);
  }

  //エリア検索ボタン
  Widget _searchButton() {
    return ElevatedButton(
      onPressed: _onMapTapped,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        elevation: 6.0,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          'このエリアを検索する',
          style: TextStyle(fontSize: 20.0, color: Colors.white),
        ),
      ),
    );
  }

  //mapの設定
  Widget _mapSection() {
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: _kGooglePlex,
      myLocationEnabled: true,
      //現在位置をマップ上に表示
      markers: _markers.values.toSet(),
      onMapCreated: _onMapCreated,
      onTap: (_) => getMiddlePoint(),
    );
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
          _mapSection(),
          _container(),
          _cardSection(),
        ],
      ),
    );
  }

  //現在位置から近くのバスケコートのマーカーを表示する
  Future<void> _setMarkers(double? latitude, double? longitude) async {
    if (latitude == null || longitude == null) {
      setState(() {
        _markers.clear();
      });
      return;
    }
    //位置情報を取得に時間かかるから非同期
    final locations = await MapRepository().getCourt(latitude, longitude);

    if (locations == null || locations.results.isEmpty) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('エラー'),
              content: Text('バスケコートが見つかりませんでした'),
              actions: [
                ElevatedButton(
                    onPressed: () => Navigator.pop(context), child: Text("ok"))
              ],
            );
          });
    }
    BitmapDescriptor markerbitmap = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(),
      "assets/images/basketball.png",
    );
    setState(() {
      _markers.clear();
      _mapModel.urls.clear();
    });

    for (final court in locations!.results) {
      await _mapModel.fetchPhoto(court.place_id);
      court.formatted_address;
      final marker = Marker(
          markerId: MarkerId(court.place_id),
          position: LatLng(court.lat, court.lng),
          infoWindow: InfoWindow(
            title: court.name,
          ),
          icon: markerbitmap,
          onTap: () {
            //MarkerIdを代入
            final markerId = MarkerId(court.place_id).toString();
            //その ID が _markers の何番目にあるかを indexOf メソッドで検索
            final index = _markers.keys.toList().indexOf(markerId);
            _pageController.animateToPage(index,
                duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
          });
      setState(() {
        _markers[MarkerId(court.place_id).toString()] = marker;
        addressList.add(court.formatted_address);
      });
    }
  }

  //カード全体の設定
  Widget _cardSection() {
    return Container(
      height: 148,
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
      child: PageView(
        onPageChanged: (int index) async {
          //スワイプ後のページのcourtを取得
          final selectedCourt = _markers.values.elementAt(index);
          //現在のズームレベルを取得
          final zoomLevel = await _controller.getZoomLevel();
          //スワイプ後のcourtの座標までカメラを移動
          _controller.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: LatLng(selectedCourt.position.latitude,
                    selectedCourt.position.longitude),
                zoom: zoomLevel,
              ),
            ),
          );
          _controller.showMarkerInfoWindow(selectedCourt.markerId);
        },
        controller: _pageController,
        children: _courtTiles(),
      ),
    );
  }

  //カード1枚1枚について
  List<Widget> _courtTiles() {
    return List.generate(
      _markers.length,
      (index) {
        final marker = _markers.values.toList()[index];
        final imageUrl = _mapModel.urls[index].toString();
        final courtAddress = addressList[index];
        return Card(
          child: SizedBox(
            height: 100,
            child: Row(
              children: [
                Container(
                  width: 120,
                  height: 120,
                  child: imageUrl != null
                      ? Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          marker.infoWindow.title.toString(),
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.bold),
                          maxLines: 3, // 最大3行まで表示
                          softWrap: true,
                        ),
                      ),
                      ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              _mapModel.bodyUrls.clear();
                            });
                            final tappedMarker =
                                _markers.values.toList()[index];
                            final placeId = tappedMarker.markerId.value;
                            await _mapModel.fetchDetailPhoto(placeId);
                            showModalBottomSheet(
                              context: context,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(25.0),
                                ),
                              ),
                              builder: (BuildContext context) {
                                return Container(
                                  height: 600,
                                  width: double.infinity,
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 30,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Text(
                                          marker.infoWindow.title.toString(),
                                          style: TextStyle(
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
                                          Column(
                                            children: [
                                              IconButton(
                                                onPressed: () {
                                                  print("test");
                                                },
                                                icon: Icon(
                                                  Icons.share,
                                                  color: Colors.blue,
                                                ),
                                              ),
                                              Text(
                                                "シェアする",
                                                style: TextStyle(
                                                    color: Colors.blue),
                                              )
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              IconButton(
                                                onPressed: () {
                                                  print("test");
                                                },
                                                icon: Icon(
                                                  Icons.navigation,
                                                  color: Colors.blue,
                                                ),
                                              ),
                                              Text(
                                                "google mapで開く",
                                                style: TextStyle(
                                                    color: Colors.blue),
                                              )
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              IconButton(
                                                onPressed: () {
                                                  print("test");
                                                },
                                                icon: Icon(
                                                  Icons.favorite,
                                                  color: Colors.blue,
                                                ),
                                              ),
                                              Text(
                                                "お気に入り",
                                                style: TextStyle(
                                                    color: Colors.blue),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.grey,
                                            width: 0.5,
                                          ),
                                        ),
                                        child: ListTile(
                                          leading: Icon(Icons.map,
                                              color: Colors.blue, size: 25),
                                          title: Text(
                                            courtAddress
                                                .replaceFirst("日本、〒", "")
                                                .replaceAll(
                                                    RegExp(r'\d{3}-\d{4}'), ''),
                                            style: TextStyle(fontSize: 14),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Expanded(
                                        child: Container(
                                          child: PageView.builder(
                                            controller: PageController(
                                                viewportFraction: 0.6),
                                            itemCount:
                                                _mapModel.bodyUrls.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              final image =
                                                  _mapModel.bodyUrls[index];
                                              return Container(
                                                padding: EdgeInsets.all(9),
                                                child: _photoItem(image),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          child: Text("詳細"))
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

  //画像
  Widget _photoItem(String image) {
    if (image == null) {
      return Container();
    } else {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Container(
          child: Image.network(
            image,
            fit: BoxFit.cover,
          ),
        ),
      );
    }
  }
}
