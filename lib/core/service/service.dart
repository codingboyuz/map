import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:map/core/models/models.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart' show BitmapDescriptor;

abstract class AppLocation {
  Future<AppLatLong> getCurrentLocation();

  Future<bool> requestPermission();

  Future<bool> checkPermission();
}

class LocationService implements AppLocation {
  final defLocation = MoscowLocation();

  @override
  Future<bool> checkPermission() {
    // TODO: implement checkPermission
    return Geolocator.checkPermission()
        .then(
          (value) =>
              value == LocationPermission.always ||
              value == LocationPermission.whileInUse,
        )
        .catchError((_) => false);
  }

  @override
  Future<AppLatLong> getCurrentLocation() async {


    // 1. Tezlik uchun avval oxirgi joylashuvni olishga urinamiz
    Position? lastPosition = await Geolocator.getLastKnownPosition();

    if (lastPosition != null) {
      return AppLatLong(lat: lastPosition.latitude, long: lastPosition.longitude);
    }

    return Geolocator.getCurrentPosition(
          // ignore: deprecated_member_use
          desiredAccuracy: LocationAccuracy.high,
        )
        .then((value) {
          return AppLatLong(lat: value.latitude, long: value.longitude);
        })
        .catchError((_) => defLocation);
  }




  @override
  Future<bool> requestPermission() {
    // TODO: implement requestPermission
    return Geolocator.requestPermission()
        .then(
          (value) =>
              value == LocationPermission.always ||
              value == LocationPermission.whileInUse,
        )
        .catchError((_) => false);
  }
}
Future<BitmapDescriptor> createCustomMarkerBitmap(int number) async {
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  final paint = Paint()..color = Colors.red;

  // Doira chizish
  canvas.drawCircle(Offset(50, 50), 40, paint);

  // Raqam yozish
  final textPainter = TextPainter(
    text: TextSpan(
      text: '$number',
      style: TextStyle(
        color: Colors.white,
        fontSize: 40,
        fontWeight: FontWeight.bold,
      ),
    ),
    textDirection: TextDirection.ltr,
  );
  textPainter.layout();
  textPainter.paint(
    canvas,
    Offset(50 - textPainter.width / 2, 50 - textPainter.height / 2),
  );

  final picture = recorder.endRecording();
  final img = await picture.toImage(100, 100);
  final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
  final bytes = byteData!.buffer.asUint8List();

  return BitmapDescriptor.fromBytes(bytes);
}