import 'package:json_annotation/json_annotation.dart';

part 'locations.g.dart';

@JsonSerializable()
class Locations {
  final List<Results> results;

  Locations({required this.results});

  factory Locations.fromJson(Map<String, dynamic> json) =>
      _$LocationsFromJson(json);

  Map<String, dynamic> toJson() => _$LocationsToJson(this);
}

@JsonSerializable()
class Results {
  final String formatted_address; //住所
  final Geometry geometry; //
  final String name; //名前
  final List<dynamic>? photos; //画像
  final String place_id; //id
  final double? rating; //緯度経度

  Results(
      {required this.formatted_address,
      required this.geometry,
      required this.name,
      this.photos,
      required this.place_id,
      this.rating});

  factory Results.fromJson(Map<String, dynamic> json) =>
      _$ResultsFromJson(json);

  Map<String, dynamic> toJson() => _$ResultsToJson(this);

  double get lat => geometry.location.lat;

  double get lng => geometry.location.lng;
}

@JsonSerializable()
class Geometry {
  final Location location;

  Geometry({required this.location});

  factory Geometry.fromJson(Map<String, dynamic> json) =>
      _$GeometryFromJson(json);

  Map<String, dynamic> toJson() => _$GeometryToJson(this);
}

@JsonSerializable()
class Location {
  final double lat;
  final double lng;

  Location({required this.lat, required this.lng});

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);

  Map<String, dynamic> toJson() => _$LocationToJson(this);
}
