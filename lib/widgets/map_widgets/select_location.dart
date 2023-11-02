import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';

class SelectLocation extends StatefulWidget {
  @override
  State<SelectLocation> createState() => _SelectLocationState();
}

class _SelectLocationState extends State<SelectLocation> {
  Position? currentPosition; //現在位置
  late GoogleMapController _controller; //google mapが使える
  late GooglePlace googlePlace;
  List<AutocompletePrediction> predictions = []; // predictionsに検索結果を格納
  List SelectLatLng = []; // 経度と緯度を格納するための配列
  late StreamSubscription<Position> positionStream; //デバイスの位置情報を取得する
  String selectedPlace = ''; // タップされた場所の説明を格納する変数

  @override
  void initState() {
    googlePlace = GooglePlace(
        "AIzaSyBRtf8M-zYgPr9sTX6Fy3JWoml6FQne5Jc"); // ⬅︎GoogleMapと同じAPIキーを指定。
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: _searchLocation(),
        actions: [
          ElevatedButton(
              onPressed: () {
                _openAlertDialog1(context);
              },
              child: Text("決定"))
        ],
      ),
      body: Stack(
        children: [
          _mapSection(),
          _searchResults(),
        ],
      ),
    );
  }

  //mapの設定
  Widget _mapSection() {
    return GoogleMap(
      compassEnabled: false,
      mapType: MapType.normal,
      initialCameraPosition: _kGooglePlex,
      myLocationEnabled: true,
      //現在位置をマップ上に表示
      onMapCreated: _onMapCreated,
      markers: _createMarkers(), // マーカーセット
    );
  }

  Future _openAlertDialog1(BuildContext context) async {
    if (selectedPlace == "") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '住所を選択してください。',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("この場所を設定しますか？"),
              content: Text(selectedPlace),
              actions: [
                TextButton(
                    onPressed: () => {
                          Navigator.pop(context),
                        },
                    child: Text("いいえ")),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context, selectedPlace);
                      Navigator.pop(context, selectedPlace);
                    },
                    child: Text("はい")),
              ],
            ));
  }

  Set<Marker> _createMarkers() {
    if (SelectLatLng.isEmpty) {
      return {};
    }
    LatLng latLng = LatLng(SelectLatLng[0], SelectLatLng[1]);
    Marker marker = Marker(
      markerId: MarkerId(latLng.toString()),
      position: latLng,
      infoWindow: InfoWindow(title: "Selected Location"),
    );
    return {marker};
  }

  //最初にマップが作成される時に呼ばれる
  Future<void> _onMapCreated(GoogleMapController controller) async {
    _controller = controller;
  }

  Widget _searchLocation() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10.0,
            spreadRadius: 1.0,
            offset: Offset(10, 10),
          ),
        ],
      ),
      child: TextFormField(
        onChanged: (value) {
          if (value.isNotEmpty) {
            autoCompleteSearch(value); // 入力される毎に引数にその入力文字を渡し、関数を実行
          } else {
            if (predictions.length > 0 && mounted) {
              // ここで配列を初期化。初期化しないと文字が入力されるたびに検索結果が蓄積されてしまう。
              setState(() {
                predictions = [];
              });
            }
          }
        },
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search),
          hintText: '場所を検索',
          hintStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _searchResults() {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: predictions.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(predictions[index]
                  .description
                  .toString()
                  .replaceFirst('日本、', '')),
              // 検索結果を表示。descriptionを指定すると場所名が表示されます。
              onTap: () async {
                selectedPlace = predictions[index]
                    .description
                    .toString(); // タップされた場所の説明を変数にセット
                print(selectedPlace);
                List? locations = await locationFromAddress(predictions[index]
                    .description
                    .toString()); // locationFromAddress()に検索結果のpredictions[index].description.toString()を渡す

                setState(() {
                  SelectLatLng = [];
                  // 取得した経度と緯度を配列に格納
                  SelectLatLng.add(locations.first.latitude);
                  SelectLatLng.add(locations.first.longitude);
                });
                _moveToSelectLocation();
              },
            ),
          );
        });
  }

  void _moveToSelectLocation() async {
    LatLng latLng = LatLng(SelectLatLng[0], SelectLatLng[1]);
    CameraPosition newCameraPosition = CameraPosition(target: latLng, zoom: 17);
    await _controller
        .animateCamera(CameraUpdate.newCameraPosition(newCameraPosition));
  }

  void autoCompleteSearch(String value) async {
    final result = await googlePlace.autocomplete.get(value, language: "ja");
    if (result != null && result.predictions != null && mounted) {
      setState(() {
        predictions = result.predictions!;
      });
    }
  }
}
