part of 'map_bloc.dart';

sealed class MapState extends Equatable {
  const MapState();
}

final class MapInitial extends MapState {
  @override
  List<Object> get props => [];
}

final class MapLoadingState extends MapState {
  const MapLoadingState();

  @override
  List<Object?> get props => [];
}

final class MapErrorState extends MapState {
  final Failure failure;

  const MapErrorState({required this.failure});

  @override
  List<Object?> get props => [failure];
}

final class SuccessSendState extends MapState {
  final MessageModel message;

  const SuccessSendState({required this.message});

  @override
  List<Object?> get props => [message];
}

final class MapLoadedState extends MapState {
  final List<MapObject> mapObject;
  final List<Point> polylinePoints;
  final Completer<YandexMapController> mapController;
  final bool check;

  const MapLoadedState(this.mapObject, this.mapController, this.polylinePoints, this.check, );

  @override
  List<Object?> get props => [mapObject, mapController, polylinePoints,check];
}

class LocationUpdate extends MapState {
  final Position? position;

  const LocationUpdate(this.position);

  @override
  List<Object?> get props => [position];
}
