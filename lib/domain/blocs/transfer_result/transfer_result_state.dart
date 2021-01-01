import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:service_route/domain/domain.dart';
import 'package:intl/intl.dart';
import 'package:service_route/infrastructure/infrastructure.dart';

class TransferResultState {}

class TransferResultReadComplete extends TransferResultState {
  TransferResultReadComplete({
    this.summary,
  });
  final TransferSummary summary;
}

class TransferResultReading extends TransferResultState {
  TransferResultReading();
}

class TransferResultReadFail extends TransferResultState {
  TransferResultReadFail({@required this.reason});

  final String reason;

  @override
  String toString() => 'CompletedTransferFail { reason: $reason }';
}

class TransferSummary {
  TransferSummary({this.distanceInMeters, this.timeInSeconds, this.totalPassengers});

  // ignore: prefer_constructors_over_static_methods
  static TransferSummary readTransferFile(String fileContent) {
    var lines = LineSplitter.split(fileContent).toList();
    double totalDistance = 0;
    int totalPassengers = 0;
    List<LatLng> locations = <LatLng>[];
    String startLine;
    String endLine;

    for (var i = 0; i < lines.length; i++) {
      var line = lines[i];

      if (!(line.startsWith(LocationType.point.index.toString()) ||
          line.startsWith(LocationType.route.index.toString()))) {
        continue;
      }

      try {
        var lineSplit = line.split(',');
        locations.add(LatLng(double.parse(lineSplit[1]), double.parse(lineSplit[2])));
      } catch (e) {
        throw AppError(message: 'Invalid transfer file line: \n $line');
      }

      if (line.startsWith(LocationType.point.index.toString())) {
        if (startLine == null && line.contains(AppString.startPoint)) {
          startLine = line;
          continue;
        }

        if (line.contains(AppString.endPoint)) {
          endLine = line;
          continue;
        }

        totalPassengers++;
      }
    }

    for (var i = 0; i < locations.length; i++) {
      var p1 = locations[i];
      if (i < locations.length - 1) {
        var p2 = locations[i + 1];
        totalDistance += Locator.distanceBetween(p1.latitude, p1.longitude, p2.latitude, p2.longitude);
      }
    }

    if (startLine.isNullOrEmpty() || startLine.isNullOrEmpty()) {
      throw AppError(message: 'Invalid Transfer File startLine || startLine Empty');
    }

    DateTime startDate = DateTime.parse(startLine.split(',')[4]);
    DateTime endDate = DateTime.parse(endLine.split(',')[4]);

    return TransferSummary(
      distanceInMeters: totalDistance,
      timeInSeconds: endDate.difference(startDate).inSeconds,
      totalPassengers: totalPassengers,
    );
  }

  final double distanceInMeters;
  final int timeInSeconds;
  final int totalPassengers;

  double get timeInMinutes {
    if (timeInSeconds == 0) {
      return 0;
    }

    return timeInSeconds / 60;
  }

  String get timeInMinutesString {
    return '${NumberFormat('###.#').format(timeInMinutes)} dk';
  }

  double get distanceInKms {
    if (distanceInMeters == 0) {
      return 0;
    }
    return distanceInMeters / 1000;
  }

  String get distanceInKmsString {
    return '≈ ${NumberFormat('###.#').format(distanceInKms)} km';
  }
}
