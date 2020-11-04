import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
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
  final int transferRouteId;
  TransferFile transferFile;

  //sentry kotasını doldurmamak için maks 3 hata yı log a yaz.
  int locationErrorLogRight = 3;
  int pointErrorLogRight = 3;

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
      name = name.isNullOrWhiteSpace() ? '${AppString.passenger} ${markers.length + 1}' : name;
      markers.add(createMarker(location, name));
      await writeToFile(LocationType.point, location, name);
      emit(state.copyWith(locating: true, location: location, markers: markers, zoom: 16));
    } catch (e, s) {
      pointErrorLogRight -= 1;
      emit(TransferFailState(reason: AppString.anUnExpectedErrorOccurred, state: state));
      //throttle error , keep sentry quota
      if (pointErrorLogRight > 0) {
        logger.error(e, stackTrace: s);
      }
    }
  }

  Future<void> _addLocation({
    Location location,
  }) async {
    try {
      var polyline = createPolyLine(location);
      await writeToFile(LocationType.route, location, '');
      emit(state.copyWith(
        locating: true,
        location: location,
        markers: state.markers,
        polylines: <Polyline>{polyline},
        zoom: 16,
      ));
    } catch (e, s) {
      locationErrorLogRight -= 1;
      emit(TransferFailState(
        reason: AppString.anUnExpectedErrorOccurred,
        state: state,
      ));
      //throttle error , keep sentry quota
      if (locationErrorLogRight > 0) {
        logger.error(e, stackTrace: s);
      }
    }
  }

  bool get locating {
    return Locator.locating;
  }

  Future<void> startLocating(int mapUpdateIntervalInSecond) async {
    try {
      Locator.getLocations(addRouteLocation);

      await Locator.start(
          notificationTitle: AppString.locationInfoCollecting,
          notificationText: AppString.lastLocation,
          updateIntervalInSecond: mapUpdateIntervalInSecond);

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

  Future<void> stopLocating() async {
    try {
      //stop never throw ex
      await Locator.stop();
      await writeToFile(LocationType.point, state.location, AppString.endPoint);
    } catch (e, s) {
      logger.error(e, stackTrace: s);
    }
  }

  Future<void> resetState() async {
    emit(TransferState.initial());
  }

  Future<void> writeToFile(
    LocationType locationType,
    Location location,
    String name,
  ) async {
    var entry = TransferFileEntry(
      locationType: locationType,
      latitude: location.latitude,
      longitude: location.longitude,
      name: name,
    );
    await transferFile.writeAsString(entry);
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

  Future<String> uploadFile() async {
    if (!kReleaseMode) {
      var fileContent = await transferFile.readAsString();
      logger.debug(fileContent);
    }

    File file = await transferFile.getFile();
    return repository.uploadTransferFile(file);
  }

  Marker createMarker(Location location, String name) {
    return Marker(
        markerId: MarkerId(location.latitude.toString()),
        position: LatLng(location.latitude, location.longitude),
        icon: BitmapDescriptor.defaultMarker,
        infoWindow: name == null
            ? null
            : InfoWindow(
                title: name,
              ));
  }

  Polyline createPolyLine(Location location) {
    List<LatLng> points;
    var oldPolyline = state.polylines.firstOrDefault();
    if (oldPolyline != null) {
      points = oldPolyline.points.toList();
    } else {
      points = <LatLng>[];
    }

    points.add(LatLng(
      location.latitude,
      location.longitude,
    ));

    return Polyline(
        polylineId: PolylineId('transfer_polyline'),
        points: points,
        color: Colors.blue.shade400,
        startCap: Cap.buttCap,
        endCap: Cap.roundCap);
  }

  @override
  Future<void> close() {
    Locator.stop();
    return super.close();
  }
}

enum LocationType { route, point }

class TransferFile {
  TransferFile(this.fileName);
  String fileName;
  bool emptyFile;

  Future<void> writeAsString(TransferFileEntry entry) async {
    final file = await getFile();
    //ilk lokasyon bilgisi , başlangıç noktasını belirtmek için point olarak
    // kayıt ediliyor.
    if (emptyFile) {
      await file.writeAsString(
          TransferFileEntry(
            locationType: LocationType.point,
            latitude: entry.latitude,
            longitude: entry.longitude,
            name: AppString.startPoint,
          ).toString(),
          mode: FileMode.append);
      emptyFile = false;
    }
    await file.writeAsString(entry.toString(), mode: FileMode.append);
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
      emptyFile = true;
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

class TransferFileEntry {
  TransferFileEntry({
    this.locationType,
    this.latitude,
    this.longitude,
    String name,
  }) : name = name ?? '';

  @override
  String toString() {
    var line = StringBuffer();
    line.write('${locationType.index},$latitude,$longitude');
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
