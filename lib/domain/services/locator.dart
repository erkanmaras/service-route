import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:service_route/infrastructure/infrastructure.dart';

class Locator {
  Locator({@required this.logger});
  Logger logger;
  bool locating = false;
  StreamSubscription<Position> positionStream;

  //sentry kotasını doldurmamak için maks 5 hata yı log a yaz.
  int locationErrorLogRight = 5;

  Future<void> start({
    @required Function(Location) callBack,
    int updateIntervalInSecond,
  }) async {
    updateIntervalInSecond ??= 10;
    locationErrorLogRight = 5;

   await callBack(await getCurrentPosition());
   
    positionStream = Geolocator.getPositionStream(
            desiredAccuracy: LocationAccuracy.bestForNavigation,
            distanceFilter: 20,
            intervalDuration: Duration(seconds: updateIntervalInSecond))
        .listen((Position position) {
      callBack(_toLocation(position));
    }, onError: (dynamic error, StackTrace stackTrace) {
      locationErrorLogRight -= 1;
      if (locationErrorLogRight > 0) {
        logger.error(error, stackTrace: stackTrace);
      }
    });

    locating = true;
  }

  Future<void> stop() async {
    locating = false;
    return positionStream?.cancel();
  }

  /// Get the last location once.
  Future<Location> getCurrentPosition() async {
    return _toLocation(await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation));
  }

  static Location _toLocation(Position position) {
    return Location(
      latitude: position.latitude,
      longitude: position.longitude,
      altitude: position.altitude,
      accuracy: position.accuracy,
    );
  }

  static Future<bool> locationServiceEnable() async {
    return Geolocator.isLocationServiceEnabled();
  }

  static Future<bool> locationPermissionGranted() async {
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return false;
    }
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever || permission == LocationPermission.denied) {
        return false;
      }
    }
    return true;
  }

  /// Calculates the distance between the supplied coordinates in meters.
  static double distanceBetween(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) {
    return Geolocator.distanceBetween(startLatitude, startLongitude, endLatitude, endLongitude);
  }
}

class Location extends Object {
  Location({this.latitude, this.longitude, this.altitude, this.accuracy});

  final double latitude;
  final double longitude;
  final double altitude;
  final double accuracy;

  @override
  bool operator ==(Object other) {
    return other is Location &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.altitude == altitude &&
        other.accuracy == accuracy;
  }

  @override
  int get hashCode => hashValues(latitude, longitude, altitude, accuracy);
}

class LocatorException {}
