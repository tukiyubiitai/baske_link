import 'dart:convert' as convert;

import 'package:http/http.dart' as http;

import '../models/model/locations.dart';

class MapRepository {
  Future<Locations?> getCourt(
    latitude,
    longitude,
  ) async {
    const getStoreURL =
        'https://maps.googleapis.com/maps/api/place/textsearch/json?query=バスケットコート&key=AIzaSyBRtf8M-zYgPr9sTX6Fy3JWoml6FQne5Jc&language=ja';
    try {
      final response = await http
          .get(Uri.parse('$getStoreURL&location=$latitude,$longitude'));
      if (response.statusCode == 200) {
        return Locations.fromJson(convert.json.decode(response.body));
      }
    } catch (e) {
      print(e);
    }
    return null;
  }
}
