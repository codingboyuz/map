import 'dart:async';

// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:map/core/error/failure.dart';
import 'package:map/core/models/location_model.dart';
import 'package:map/core/models/models.dart';
import 'package:map/core/service/service.dart';
import 'package:map/features/map/domain/usecase/map_use_case.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

part 'map_event.dart';

part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  bool isLoading = false;
  int count = 0;
  final MapUseCase mapUseCase;
  final Completer<YandexMapController> _mapController =
      Completer<YandexMapController>();
  List<MapObject> _mapObjects = [];
  final List<Point> _polylinePoints = [];

  MapBloc({required this.mapUseCase}) : super(MapLoadingState()) {
    // Xaritani ochish hodisasi
    on<OnTabMapEvent>(_onTabMap);

    // Ruxsat va joylashuv olish hodisasi
    on<InitPermissionAndFetchEvent>(_initPermissionAndFetch);

    // Joriy joylashuvni olish hodisasi
    on<FetchCurrentLocationEvent>((
      FetchCurrentLocationEvent event,
      Emitter<MapState> emit,
    ) async {
      _fetchCurrentLocation();
    });

    on<DeleteMarkerEvent>(_deleteMarker);

    on<SendLocationEvent>(_sendLocation);
  }

  // Xaritada joylashuvni olish va ko'chirish
  Future<void> _initPermissionAndFetch(
    InitPermissionAndFetchEvent event,
    Emitter<MapState> emit,
  ) async {
    if (!await LocationService().checkPermission()) {
      await LocationService().requestPermission();
    }
    emit(MapLoadedState(_mapObjects, _mapController));
    await _fetchCurrentLocation();
  }

  void _deleteMarker(DeleteMarkerEvent event, Emitter<MapState> emit) {
    _mapObjects = [];
    _polylinePoints.clear();

    emit(MapLoadedState(_mapObjects, _mapController));
  }

  // Joriy joylashuvni olish
  Future<void> _fetchCurrentLocation() async {
    AppLatLong appLatLong;
    const defLocation = MoscowLocation();

    try {
      appLatLong = await LocationService().getCurrentLocation();
    } catch (_) {
      appLatLong = defLocation;
    }

    await _moveToLocation(appLatLong);
  }

  // Map controller yordamida joylashuvni ko'chirish
  Future<void> _moveToLocation(AppLatLong location) async {
    final controller = await _mapController.future;

    await controller.moveCamera(
      animation: const MapAnimation(type: MapAnimationType.linear, duration: 1),
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: Point(latitude: location.lat, longitude: location.long),
          zoom: 20,
        ),
      ),
    );
  }

  // Xaritada marker qo'shish
  Future<void> _onTabMap(OnTabMapEvent event, Emitter<MapState> emit) async {
    final controller = await _mapController.future;
    final cameraPosition = await controller.getCameraPosition();
    final centerPoint = cameraPosition.target;
    count++;
    emit(MapLoadedState(_mapObjects, _mapController));

    await _addMarkers(point: centerPoint, count: count, emit: emit);
  }

  Future<void> _addMarkers({
    required Point point,
    required int count,
    required Emitter<MapState> emit,
  }) async {
    final markerIcon = await createCustomMarkerBitmap(count);
    final marker = PlacemarkMapObject(
      mapId: MapObjectId('placemark_$count'),
      point: point,
      icon: PlacemarkIcon.single(PlacemarkIconStyle(image: markerIcon)),
    );

    _polylinePoints.add(point);

    final polyline = PolylineMapObject(
      mapId: MapObjectId('polyline_${DateTime.now().millisecondsSinceEpoch}'),
      polyline: Polyline(points: _polylinePoints),
      strokeColor: Colors.blue,
      strokeWidth: 4.0,
    );

    // YANGI list hosil qilamiz va markerlar qo‘shamiz
    _mapObjects =
        List.from(_mapObjects)
          ..add(marker)
          ..add(polyline);

    // Emit qilamiz — bu UI ni yangilaydi
    emit(MapLoadedState(_mapObjects, _mapController));
  }

  Future<void> _sendLocation(
    SendLocationEvent event,
    Emitter<MapState> emit,
  ) async {
    List<LocationElement> locations = [];
    int id = 0;
    if (_polylinePoints.isNotEmpty) {
      for (Point point in _polylinePoints) {
        id++;
        locations.add(
          LocationElement(
            id: id,
            latitude: point.latitude,
            longitude: point.longitude,
          ),
        );
      }
    }
    if (locations.isNotEmpty) {
      final Location location = Location(locations: locations);
      final result = await mapUseCase.call(location);
      result.fold(
        (left) => emit(MapErrorState(failure: Failure(message: left.message))),
        (right) => SuccessSendState(data: right.locations),
      );
    }
  }
}
