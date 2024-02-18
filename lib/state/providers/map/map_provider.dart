import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

final mapProvider = ChangeNotifierProvider((ref) => MapProvider());

class MapProvider extends ChangeNotifier {
  GoogleMapController? _mapController;

  GoogleMapController? get mapController => _mapController;

  final List<String> _urls = []; //コート画像
  final List<String> _bodyUrls = []; //コート詳細画像

  Position? _currentPosition; //現在地
  Position? get currentPosition => _currentPosition;

  final Map<String, Marker> _markers = {}; //マーカー
  final List<String> _addressList = []; //住所
  Uri? _mapURL; //マップのURL
  int? _selectCourt; //選択されたコート
  bool _loadMap = false; //mapの完了を通知させる

  bool _loading = false; //ロード中かどうか

  Map<String, Marker> get markers => _markers;

  List<String> get addressList => _addressList;

  List<String> get urls => _urls;

  List<String> get bodyUrls => _bodyUrls;

  Uri? get mapURL => _mapURL;

  int? get selectCourt => _selectCourt;

  bool get loadMap => _loadMap;

  bool get loading => _loading;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void setLoadMap(bool value) {
    _loadMap = value;
    notifyListeners();
  }

  void selectIndex(int index) {
    _selectCourt = index;
    notifyListeners();
  }

  void clearSelect() {
    _selectCourt = null;
    notifyListeners();
  }

  void addCurrentPosition(Position position) {
    _currentPosition = position;
    notifyListeners();
  }

  void addAddress(String address) {
    _addressList.add(address);
    notifyListeners();
  }

  void addMaker(String placeId, Marker marker) {
    _markers[placeId] = marker;
    notifyListeners();
  }

  void addMapController(GoogleMapController controller) {
    _mapController = controller;
    notifyListeners();
  }

  void addUrls(String url) {
    _urls.add(url);
    notifyListeners();
  }

  void addBodyUrl(String url) {
    _bodyUrls.add(url);
    notifyListeners();
  }

  void clearAddress() {
    _addressList.clear();
    notifyListeners();
  }

  void clearUrls() {
    _urls.clear();
    notifyListeners();
  }

  void clearMakers() {
    _markers.clear();
    notifyListeners();
  }

  set addMapUrl(Uri uri) {
    _mapURL = uri;
    notifyListeners();
  }

  void clearBodyUrls() {
    _bodyUrls.clear();
    notifyListeners();
  }
}
