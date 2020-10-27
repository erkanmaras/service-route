import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:locator/locator.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:service_route/domain/bloc/transfer/transfer_state.dart';
import 'package:service_route/domain/domain.dart';
import 'package:service_route/infrastructure/infrastructure.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
export 'package:service_route/domain/bloc/transfer/transfer_state.dart';

class TransferBloc extends Cubit<TransferState> {
  TransferBloc({@required this.transferRouteId, @required this.repository, @required this.logger})
      : assert(logger != null),
        super(TransferState.initial()) {
    transferFile = TransferFile(transferRouteId.toString());
  }

  final Logger logger;
  final IServiceRouteRepository repository;
  final double transferRouteId;
  TransferFile transferFile;
  int maxLocationErrorCount = 3;

  Future<void> addPointLocation(Location location, String pointName) async {
    return _addMarker(
      location: location,
      name: pointName,
    );
  }

  Future<void> addRouteLocation(Location location) async {
    return _addLocation(
      location: location,
    );
  }

  Future<void> _addMarker({
    Location location,
    String name,
  }) async {
    try {
      var markers = state.markers;
      markers.add(Marker(
          markerId: MarkerId(location.latitude.toString()),
          position: LatLng(location.latitude, location.longitude),
          icon: BitmapDescriptor.defaultMarker,
          infoWindow: InfoWindow(
            title: name ?? AppString.passenger,
          )));
      await _writeToFile(LocationType.point, location, name);
      emit(state.copyWith(locating: true, location: location, markers: markers, zoom: 16));
    } catch (e, s) {
      maxLocationErrorCount -= 1;
      emit(TransferFailState(reason: AppString.anUnExpectedErrorOccurred, state: state));
      //throttle error , keep sentry quota
      if (maxLocationErrorCount > 0) {
        logger.error(e, stackTrace: s);
      }
    }
  }

  Future<void> _addLocation({
    Location location,
  }) async {
    try {
      List<LatLng> points;
      var oldPolyline = state.polylines.firstOrDefault();
      if (oldPolyline != null) {
        points = oldPolyline.points.toList();
      } else {
        points = <LatLng>[];
      }
      points.add(LatLng(location.latitude, location.longitude));
      var polyline = Polyline(
        polylineId: PolylineId(location.latitude.toString()),
        points: points,
        color: Colors.blue,
      );
      await _writeToFile(LocationType.route, location, '');
      emit(state.copyWith(
        locating: true,
        location: location,
        markers: state.markers,
        polylines: <Polyline>{polyline},
        zoom: 16,
      ));
    } catch (e, s) {
      maxLocationErrorCount -= 1;
      emit(TransferFailState(
        reason: AppString.anUnExpectedErrorOccurred,
        state: state,
      ));
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
      emit(TransferFailState(reason: e.message, state: state));
      logger.error(e, stackTrace: s);
    } catch (e, s) {
      emit(TransferFailState(reason: AppString.anUnExpectedErrorOccurred, state: state));
      logger.error(e, stackTrace: s);
    }
  }

  void stopLocating() {
    emit(TransferState.initial());
  }

  Future<void> _writeToFile(
    LocationType locationType,
    Location location,
    String name,
  ) async {
    var line = _RouteFileEntry(
            locationType: locationType, latitude: location.latitude, longitude: location.longitude, name: name)
        .toString();
    await transferFile.writeAsString(line);
  }

  Future<void> deleteFile() async {
    return transferFile.delete();
  }

  Future<bool> fileExist() async {
    return transferFile.fileExists();
  }

  Future<File> getFile() async {
    return transferFile.getFile();
  }

  Future<void> uploadFile() async {
    var fileContent = await transferFile.readAsString();
    logger.debug(fileContent);
    await repository.uploadTransferFile(await transferFile.getFile());
  }
}

enum LocationType { route, point }

class TransferFile {
  TransferFile(this.fileName);
  String fileName;
  Future<void> writeAsString(String log) async {
    final file = await getFile();
    await file.writeAsString(log, mode: FileMode.append);
  }

  Future<bool> fileExists() async {
    final path = await _getFilePath();
    final file = File(path);
    return file.existsSync();
  }

  Future<File> getFile() async {
    final path = await _getFilePath();
    final file = File(path);
    if (!file.existsSync()) {
      await file.writeAsString('');
    }
    return file;
  }

  Future<String> _getFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/$fileName.dat';
  }

  Future<String> readAsString() async {
    final file = await getFile();
    return file.readAsString();
  }

  Future<void> delete() async {
    final file = await getFile();
    await file.delete();
  }
}

class _RouteFileEntry {
  _RouteFileEntry({
    this.locationType,
    this.latitude,
    this.longitude,
    String name,
  }) : name = name ?? '';

  @override
  String toString() {
    var line = StringBuffer();
    line.write(locationType.index);
    line.write(',$latitude');
    line.write(',$longitude');

    if (locationType.index == LocationType.point.index) {
      line.write(',"${name ?? ""}",${Clock().now().toIso8601String()}');
    }

    line.writeln();
    return line.toString();
  }

  final String name;
  final LocationType locationType;
  final double latitude;
  final double longitude;
}
