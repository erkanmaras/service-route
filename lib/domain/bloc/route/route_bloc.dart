import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:locator/locator.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:service_route/domain/bloc/route/route_state.dart';
import 'package:service_route/domain/domain.dart';
import 'package:service_route/infrastructure/infrastructure.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
export 'package:service_route/domain/bloc/route/route_state.dart';

class RouteBloc extends Cubit<RouteState> {
  RouteBloc({@required this.repository, @required this.logger})
      : assert(logger != null),
        super(RouteState.initial());

  final Logger logger;
  final IServiceRouteRepository repository;

  int maxLocationErrorCount = 3;
  Future<void> addPassengerLocation(Location location) async {
    return _addMarker(
      LocationType.passenger,
      location,
      BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    );
  }

  Future<void> addRouteLocation(Location location) async {
    return _addMarker(
      LocationType.route,
      location,
      BitmapDescriptor.defaultMarker,
    );
  }

  Future<void> _addMarker(
    LocationType locationType,
    Location location,
    BitmapDescriptor icon,
  ) async {
    try {
      var markers = state.markers;
      markers.add(Marker(
        markerId: MarkerId(location.latitude.toString()),
        position: LatLng(location.latitude, location.longitude),
        icon: icon,
      ));
      await _writeToFile(locationType, location);
      emit(state.copyWith(locating: true, location: location, markers: markers, zoom: 16));
    } catch (e, s) {
      maxLocationErrorCount -= 1;
      emit(RouteFailState(reason: AppString.anUnExpectedErrorOccurred, state: state));
      //throttle error , keep sentry quota
      if (maxLocationErrorCount > 0) {
        logger.error(e, stackTrace: s);
      }
    }
  }

  Future<void> startLocating() async {
    try {
      await deleteFile();
      emit(state.copyWith(locating: true));
    } on AppException catch (e, s) {
      emit(RouteFailState(reason: e.message, state: state));
      logger.error(e, stackTrace: s);
    } catch (e, s) {
      emit(RouteFailState(reason: AppString.anUnExpectedErrorOccurred, state: state));
      logger.error(e, stackTrace: s);
    }
  }

  void stopLocating() {
    emit(RouteState.initial());
  }

  Future<void> _writeToFile(
    LocationType locationType,
    Location location,
  ) async {
    var map = _RouteFileEntry(locationType: locationType, latitude: location.latitude, longitude: location.longitude)
        .toJson();
    await _RouteFile.writeAsString(jsonEncode(map));
  }

  Future<void> deleteFile() async {
    return _RouteFile.delete();
  }

  Future<bool> fileExist() async {
    return _RouteFile.fileExists();
  }

  Future<File> getFile() async {
    return _RouteFile.getFile();
  }

  Future<void> uploadFile() async {
    var fileContent = await _RouteFile.readAsString();
    logger.debug(fileContent);
    await repository.uploadServiceRouteFile(await _RouteFile.getFile());
  }
}

enum LocationType { route, passenger }

class _RouteFile {
  static Future<void> writeAsString(String log) async {
    final file = await getFile();
    await file.writeAsString(log, mode: FileMode.append);
  }

  static Future<bool> fileExists() async {
    final path = await _getFilePath();
    final file = File(path);
    return file.existsSync();
  }

  static Future<File> getFile() async {
    final path = await _getFilePath();
    final file = File(path);
    if (!file.existsSync()) {
      await file.writeAsString('');
    }
    return file;
  }

  static Future<String> _getFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/service_route.dat';
  }

  static Future<String> readAsString() async {
    final file = await getFile();
    return file.readAsString();
  }

  static Future<void> delete() async {
    final file = await getFile();
    await file.delete();
  }
}

class _RouteFileEntry {
  _RouteFileEntry({this.locationType, this.latitude, this.longitude});

  // factory _RouteFileEntry.fromJson(Map<String, dynamic> json) => _RouteFileEntry(
  //       locationType: LocationType.values[json.getValue<int>('locationType')],
  //       latitude: json.getValue<double>('latitude'),
  //       longitude: json.getValue<double>('longitude'),
  //     );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'locationType': locationType.index,
        'latitude': latitude,
        'longitude': longitude,
      };

  final LocationType locationType;
  final double latitude;
  final double longitude;
}
