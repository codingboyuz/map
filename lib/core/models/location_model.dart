// To parse this JSON data, do
//
//     final location = locationFromJson(jsonString);

import 'dart:convert';

Location locationFromJson(String str) => Location.fromJson(json.decode(str));

String locationToJson(Location data) => json.encode(data.toJson());

class Location {
  List<LocationElement> locations;

  Location({
    required this.locations,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    locations: List<LocationElement>.from(json["locations"].map((x) => LocationElement.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "locations": List<dynamic>.from(locations.map((x) => x.toJson())),
  };
}

class LocationElement {
  int id;
  double latitude;
  double longitude;

  LocationElement({
    required this.id,
    required this.latitude,
    required this.longitude,
  });

  factory LocationElement.fromJson(Map<String, dynamic> json) => LocationElement(
    id: json["id"],
    latitude: json["latitude"]?.toDouble(),
    longitude: json["longitude"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "latitude": latitude,
    "longitude": longitude,
  };
}
