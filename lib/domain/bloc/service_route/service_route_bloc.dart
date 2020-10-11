import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:locator/locator.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:service_route/domain/bloc/service_route/service_route_state.dart';
import 'package:service_route/infrastructure/infrastructure.dart';
export 'package:service_route/domain/bloc/service_route/service_route_state.dart';

class ServiceRouteBloc extends Cubit<ServiceRouteState> {
  ServiceRouteBloc({@required this.logger})
      : assert(logger != null),
        super(ServiceRouteState.initial());

  final Logger logger;

  void addPassengerMarker(Location location) {
    _addMarker(MarkerType.location, location, BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue));
  }

  void addLocationMarker(Location location) {
    _addMarker(MarkerType.location, location, BitmapDescriptor.defaultMarker);
  }

  void _addMarker(MarkerType markerType, Location location, BitmapDescriptor icon) {
    try {
      var markers = state.markers;
      markers.add(Marker(
        markerId: MarkerId(location.latitude.toString()),
        position: LatLng(location.latitude, location.longitude),
        icon: icon,
      ));
      emit(state.copyWith(locating: true, location: location, markers: markers, zoom: 16));
    } on AppException catch (e, s) {
      emit(ServiceRouteMapFailState(reason: e.message, state: state));
      logger.error(e, stackTrace: s);
    } catch (e, s) {
      emit(ServiceRouteMapFailState(reason: AppString.anUnExpectedErrorOccurred, state: state));
      logger.error(e, stackTrace: s);
    }
  }

  void startLocating() {
    try {
      emit(state.copyWith(locating: true));
    } on AppException catch (e, s) {
      emit(ServiceRouteMapFailState(reason: e.message, state: state));
      logger.error(e, stackTrace: s);
    } catch (e, s) {
      emit(ServiceRouteMapFailState(reason: AppString.anUnExpectedErrorOccurred, state: state));
      logger.error(e, stackTrace: s);
    }
  }

  void stopLocating() {
    emit(ServiceRouteState.initial());
  }
}

enum MarkerType { location, passenger }
