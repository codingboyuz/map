import 'dart:async';

import 'package:flutter/material.dart';
import 'package:map/models.dart';
import 'package:map/service.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AndroidYandexMap.useAndroidViewSurface = false;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yandex Map Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MapScreen(),
    );
  }
}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<YandexMapController> _mapController = Completer<YandexMapController>();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _initPermissionAndFetch();
  }

  Future<void> _initPermissionAndFetch() async {
    if (!await LocationService().checkPermission()) {
      await LocationService().requestPermission();
    }
    await _fetchCurrentLocation();
  }

  Future<void> _fetchCurrentLocation() async {
    setState(() => isLoading = true);

    AppLatLong appLatLong;
    const defLocation = MoscowLocation();

    try {
      appLatLong = await LocationService().getCurrentLocation();
      print("AppLat =================================== ${appLatLong.long }: ${appLatLong.lat}");
    } catch (_) {
      appLatLong = defLocation;
    }


    await _moveToLocation(appLatLong);
    setState(() => isLoading = false);
  }

  Future<void> _moveToLocation(AppLatLong location) async {
    final controller = await _mapController.future;

    await controller.moveCamera(
      animation: const MapAnimation(
        type: MapAnimationType.linear,
        duration: 1,
      ),
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: Point(latitude: location.lat, longitude: location.long),
          zoom: 14,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          YandexMap(
            onMapCreated: (controller) async {
              _mapController.complete(controller);
              await _fetchCurrentLocation();
            },
          ),
          const Center(
            child: Icon(Icons.location_on, size: 35, color: Colors.red),
          ),
          if (isLoading)
            const Center(child: CircularProgressIndicator()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _fetchCurrentLocation,
        child: const Icon(Icons.gps_fixed, color: Colors.black),
        backgroundColor: Colors.white,
      ),
    );
  }
}
