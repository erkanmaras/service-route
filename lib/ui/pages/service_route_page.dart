import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:locator/locator.dart';
import 'package:service_route/data/data.dart';
import 'package:service_route/infrastructure/app_permission.dart';
import 'package:service_route/ui/ui.dart';
import 'package:service_route/infrastructure/infrastructure.dart';

class ServiceRoutePage extends StatefulWidget {
  ServiceRoutePage({@required this.serviceRoute});

  final ServiceRoute serviceRoute;
  @override
  _ServiceRoutePageState createState() => _ServiceRoutePageState();
}

class _ServiceRoutePageState extends State<ServiceRoutePage> {
  GoogleMapController mapController;
  final Set<Marker> markers = {};
  int markerCounter = 0;
  Location location;
  double zoomLevel = 5;
  bool tracking = false;
  AppTheme appTheme;
  @override
  void initState() {
    super.initState();
    Locator.getLocations((newLocation) {
      // if (location.latitude == newLocation.latitude &&
      //     location.longitude == newLocation.longitude) {
      //   return;
      // }
      setState(() {
        location = newLocation;
        addLocationMarker(newLocation);
        mapController.moveCamera(CameraUpdate.newLatLng(toLatLng(newLocation)));
      });
    });
  }

  @override
  void dispose() {
    Locator.stop();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    appTheme = context.getTheme();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: !tracking,
        title: const Text('Servis Rota'),
        actions: <Widget>[],
      ),
      body: Stack(children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: currentLocation(),
            zoom: zoomLevel,
          ),
          zoomGesturesEnabled: true,
          zoomControlsEnabled: false,
          buildingsEnabled: false,
          indoorViewEnabled: false,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          trafficEnabled: false,
          markers: Set<Marker>.of(markers),
          onMapCreated: onMapCreated,
          onCameraMove: (position) {
            zoomLevel = position.zoom;
          },
        ),
        buildActionButtons()
      ]),
    );
  }

  Widget buildActionButtons() {
    if (tracking) {
      return buildTrackingAction();
    }
    return buildStartAction();
  }

  Widget buildStartAction() {
    return Align(
      alignment: Alignment.center,
      child: buildButton(color: appTheme.colors.success, onPressed: onStart, text: 'Başla', large: true),
    );
  }

  Widget buildTrackingAction() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: ExpandedRow(
          children: [
            buildButton(
              color: appTheme.colors.primary,
              onPressed: onNewPassenger,
              text: 'Yolcu Al',
            ),
            buildButton(
              color: appTheme.colors.error,
              onPressed: onStop,
              text: 'Bitir',
            ),
          ],
        ),
      ),
    );
  }

  Future<void> onMapCreated(GoogleMapController mapController) async {
    this.mapController = mapController;
  }

  LatLng currentLocation() {
    if (location == null) {
      return LatLng(39.453553, 33.957929);
    }
    return LatLng(location.latitude, location.longitude);
  }

  Future<void> onStart() async {
    var locationPermissionGranted = await AppPermission.locationPermissionGranted();
    if (!locationPermissionGranted) {
      await MessageDialog.error(context: context, message: 'locationPermissionNotGranted');
      return;
    }

    var locationServiceEnable = await AppPermission.locationServiceEnable();
    if (!locationServiceEnable) {
      await MessageDialog.error(context: context, message: 'locationServiceNotEnable');
      return;
    }

    await Locator.start(
      notificationTitle: 'Konum bilgisi alınıyor...',
      notificationText: 'Son konum',
      updateIntervalInSecond: 10,
    );
    setState(() {
      tracking = true;
    });
  }

  Future<void> onStop() async {
    await Locator.stop();
    markers.clear();
    setState(() {
      tracking = false;
    });
  }

  Future<void> onNewPassenger() async {
    Location newLocation = await Locator.getLastLocation();
    setState(() {
      location = newLocation;
      addPassengerMarker(newLocation);
    });
  }

  LatLng toLatLng(Location location) {
    if (location == null) {
      return null;
    }
    return LatLng(location.latitude, location.longitude);
  }

  void addPassengerMarker(Location location) {
    addMarker(MarkerType.location, location, BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue));
  }

  void addLocationMarker(Location location) {
    addMarker(MarkerType.location, location, BitmapDescriptor.defaultMarker);
  }

  void addMarker(MarkerType markerType, Location location, BitmapDescriptor icon) {
    markerCounter += 1;
    markers.add(Marker(
      markerId: MarkerId(location.latitude.toString()),
      position: LatLng(location.latitude, location.longitude),
      infoWindow: InfoWindow(
        title: 'Marker Info $markerCounter',
        snippet: 'Marker Snipped',
      ),
      icon: icon,
    ));
  }

  Widget buildButton(
      {@required VoidCallback onPressed, @required String text, @required Color color, bool large = false}) {
    var sizeMultiplier = large ? 3.0 : 2.0;
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: Size(kMinInteractiveDimension * sizeMultiplier, kMinInteractiveDimension * sizeMultiplier),
          elevation: 10,
          primary: color,
          shape: CircleBorder(),
          side: BorderSide(color: Colors.white, width: sizeMultiplier),
        ),
        onPressed: onPressed,
        child: Text(text, style: appTheme.textStyles.title.copyWith(color: appTheme.colors.fontLight)));
  }
}

enum MarkerType { location, passenger }
