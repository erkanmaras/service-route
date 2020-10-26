import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:locator/locator.dart';

class TransferState {
  TransferState({this.locating, this.location, this.zoom, this.markers});
  factory TransferState.initial() {
    return TransferState(
      location: Location(latitude: 39.453553, longitude: 33.957929),
      zoom: 5,
      markers: {},
      locating: false,
    );
  }

  final bool locating;
  final Location location;
  final double zoom;
  final Set<Marker> markers;

  TransferState copyWith({
    bool locating,
    Location location,
    double zoom,
    Set<Marker> markers,
  }) {
    return TransferState(
      locating: locating ?? this.locating,
      location: location ?? this.location,
      zoom: zoom ?? this.zoom,
      markers: markers ?? this.markers,
    );
  }

  LatLng get latLng => LatLng(location.latitude, location.longitude);
}

class TransferFailState extends TransferState {
  TransferFailState({@required this.reason, TransferState state})
      : super(
          location: state.location,
          zoom: state.zoom,
          markers: state.markers,
          locating: state.locating,
        );

  final String reason;
}
