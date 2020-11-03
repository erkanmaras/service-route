import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:locator/locator.dart';
import 'package:service_route/domain/domain.dart';
import 'package:intl/intl.dart';

class TransferResultState {}

class TransferResultReadComplete extends TransferResultState {
  TransferResultReadComplete({
    this.summary,
  });
  final TransferSummary summary;
}

class TransferResultInitial extends TransferResultState {
  TransferResultInitial();
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
    var startDate = DateTime.parse(lines.first.split(',')[4]);
    var endDate = DateTime.parse(lines.last.split(',')[4]);
    double totalDistance = 0;
    int totalPassengers = 0;

    //skip first and last line(start,end time info)
    var startIndex = 1;
    var endIndex = lines.length - 1;
    for (var i = startIndex; i < endIndex; i++) {
      var line = lines[i];
      if (line.startsWith(LocationType.point.index.toString())) {
        totalPassengers++;
      }

      if (i < endIndex - 1) {
        var nextLine = lines[i + 1];
        var line1Split = line.split(',');
        var line2Split = nextLine.split(',');
        var lat1 = double.parse(line1Split[1]);
        var lng1 = double.parse(line1Split[2]);
        var lat2 = double.parse(line2Split[1]);
        var lng2 = double.parse(line2Split[2]);

        totalDistance += Locator.distanceBetween(lat1, lng1, lat2, lng2);
      }
    }

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
    return '${NumberFormat('###.#').format(distanceInKms)} km';
  }
}
