import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:locator/locator.dart';
import 'package:service_route/data/data.dart';
import 'package:service_route/domain/bloc/service_route/service_route_state.dart';
import 'package:service_route/domain/domain.dart';
import 'package:service_route/infrastructure/app_permission.dart';
import 'package:service_route/ui/ui.dart';
import 'package:service_route/infrastructure/infrastructure.dart';
import 'package:wakelock/wakelock.dart';

class ServiceRoutePage extends StatefulWidget {
  ServiceRoutePage({@required this.serviceRoute});

  final ServiceRoute serviceRoute;
  @override
  _ServiceRoutePageState createState() => _ServiceRoutePageState();
}

class _ServiceRoutePageState extends State<ServiceRoutePage> {
  _ServiceRoutePageState()
      : logger = AppService.get<Logger>(),
        appNavigator = AppService.get<AppNavigator>();

  GoogleMapController mapController;
  bool keepScreenOn = false;
  AppTheme appTheme;
  AppNavigator appNavigator;
  Logger logger;

  @override
  void initState() {
    super.initState();
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
    return MultiBlocProvider(
      providers: [
        BlocProvider<ServiceRouteBloc>(
          create: (BuildContext context) => ServiceRouteBloc(logger: logger),
        ),
      ],
      child: BlocConsumer<ServiceRouteBloc, ServiceRouteState>(listener: (context, state) {
        if (state is ServiceRouteMapFailState) {
          SnackBarAlert.error(context: context, message: state.reason);
          return;
        }
        mapController.moveCamera(CameraUpdate.newLatLngZoom(state.latLng, state.zoom));
      }, builder: (context, state) {
        var initialState = ServiceRouteState.initial();
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: !state.locating,
            title: const Text(AppString.serviceRouteList),
            actions: <Widget>[
              Row(
                children: [
                  Text(AppString.keepScreenOn),
                  StatefulBuilder(
                    builder: (context, setState) => Switch(
                      value: keepScreenOn,
                      onChanged: (value) {
                        setState(() {
                          keepScreenOn = value;
                          Wakelock.toggle(enable: keepScreenOn);
                        });
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
          body: Stack(children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: initialState.latLng,
                zoom: initialState.zoom,
              ),
              buildingsEnabled: false,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              markers: state.markers,
              onMapCreated: onMapCreated,
            ),
            buildActionButtons(context, state)
          ]),
        );
      }),
    );
  }

  Widget buildActionButtons(BuildContext context, ServiceRouteState state) {
    if (state.locating) {
      return buildTrackingAction(context);
    }
    return buildStartAction(context);
  }

  Widget buildStartAction(
    BuildContext context,
  ) {
    return Align(
      alignment: Alignment.center,
      child: buildButton(
        color: appTheme.colors.success,
        onPressed: () => onStart(context),
        text: AppString.start,
        large: true,
      ),
    );
  }

  Widget buildTrackingAction(
    BuildContext context,
  ) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            buildButton(
              color: appTheme.colors.primary,
              onPressed: () => onNewPassenger(context),
              text: AppString.takePassenger,
            ),
            buildButton(
              color: appTheme.colors.error,
              onPressed: () async {
                await onStop(context);
              },
              text: AppString.done,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> onMapCreated(GoogleMapController mapController) async {
    this.mapController = mapController;
  }

  Future<void> onStart(
    BuildContext context,
  ) async {
    var locationPermissionGranted = await AppPermission.locationPermissionGranted();
    if (!locationPermissionGranted) {
      await MessageDialog.error(context: context, message: AppString.locationPermissionNotGranted);
      return;
    }

    var locationServiceEnable = await AppPermission.locationServiceEnable();
    if (!locationServiceEnable) {
      await MessageDialog.error(context: context, message: AppString.locationServiceNotEnable);
      return;
    }

    Locator.getLocations((newLocation) {
      context.bloc<ServiceRouteBloc>().addLocationMarker(newLocation);
    });

    await Locator.start(
      notificationTitle: AppString.locationInfoCollecting,
      notificationText: AppString.lastLocation,
      updateIntervalInSecond: 10,
    );

    // Location newLocation = await Locator.getLastLocation();

    context.bloc<ServiceRouteBloc>().startLocating();
  }

  Future<void> onStop(
    BuildContext context,
  ) async {
    var result = await MessageSheet.question(
        context: context, message: AppString.areYouSureWantToCompleteServiceRoute, buttons: DialogButton.yesNo);
    if (result == DialogResult.yes) {
      await Locator.stop();
      appNavigator.pop(context);
      //context.bloc<ServiceRouteBloc>().stopLocating();
    }
  }

  Future<void> onNewPassenger(
    BuildContext context,
  ) async {
    Location newLocation = await Locator.getLastLocation();
    context.bloc<ServiceRouteBloc>().addPassengerMarker(newLocation);
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
