part of 'map_bloc.dart';

sealed class MapEvent extends Equatable {
  const MapEvent();
  @override
  List<Object?> get props => [];
}

final class OnTabMapEvent  extends MapEvent{}
final class InitPermissionAndFetchEvent  extends MapEvent{}
final class FetchCurrentLocationEvent  extends MapEvent{}
final class DeleteMarkerEvent  extends MapEvent{}
final class SendLocationEvent  extends MapEvent{}
final class ConnectionWifiCheckEvent  extends MapEvent{}

