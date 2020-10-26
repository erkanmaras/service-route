import 'package:flutter/cupertino.dart';
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
  TransferBloc({@required this.repository, @required this.logger})
      : assert(logger != null),
        super(TransferState.initial());

  final Logger logger;
  final IServiceRouteRepository repository;

  int maxLocationErrorCount = 3;
  Future<void> addPointLocation(Location location, String pointName) async {
    return _addLocation(
      LocationType.point,
      location,
      BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      name: pointName,
    );
  }

  Future<void> addRouteLocation(Location location) async {
    return _addLocation(
      LocationType.route,
      location,
      BitmapDescriptor.defaultMarker,
    );
  }

  Future<void> _addLocation(
    LocationType locationType,
    Location location,
    BitmapDescriptor icon, {
    String name,
  }) async {
    try {
      var markers = state.markers;
      markers.add(Marker(
        markerId: MarkerId(location.latitude.toString()),
        position: LatLng(location.latitude, location.longitude),
        icon: icon,
      ));
      await _writeToFile(locationType, location, name);
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

  Future<void> _writeToFile(LocationType locationType, Location location, String name) async {
    var line = _RouteFileEntry(
            locationType: locationType, latitude: location.latitude, longitude: location.longitude, name: name)
        .toString();
    await _TransferFile.writeAsString(line);
  }

  Future<void> deleteFile() async {
    return _TransferFile.delete();
  }

  Future<bool> fileExist() async {
    return _TransferFile.fileExists();
  }

  Future<File> getFile() async {
    return _TransferFile.getFile();
  }

  Future<void> uploadFile() async {
    var fileContent = await _TransferFile.readAsString();
    logger.debug(fileContent);
    await repository.uploadTransferFile(await _TransferFile.getFile());
  }
}

enum LocationType { route, point }

class _TransferFile {
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
  _RouteFileEntry({
    this.locationType,
    this.latitude,
    this.longitude,
    this.name,
  });

  @override
  String toString() {
    var line = StringBuffer();
    line.write(locationType.index);
    line.write(',$latitude');
    line.write(',$longitude');
    if (!name.isNullOrWhiteSpace()) {
      line.write(',$name');
    }
    line.writeln();

    return line.toString();
  }

  final String name;
  final LocationType locationType;
  final double latitude;
  final double longitude;
}
