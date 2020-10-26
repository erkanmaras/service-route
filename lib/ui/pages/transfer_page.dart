import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:locator/locator.dart';
import 'package:service_route/data/data.dart';
import 'package:service_route/domain/domain.dart';
import 'package:service_route/infrastructure/app_permission.dart';
import 'package:service_route/ui/ui.dart';
import 'package:service_route/infrastructure/infrastructure.dart';
import 'package:wakelock/wakelock.dart';

class TransferPage extends StatefulWidget {
  TransferPage({@required this.serviceRoute});

  final TransferRoute serviceRoute;
  @override
  _TransferPageState createState() => _TransferPageState();
}

class _TransferPageState extends State<TransferPage> {
  _TransferPageState()
      : logger = AppService.get<Logger>(),
        repository = AppService.get<IServiceRouteRepository>(),
        appNavigator = AppService.get<AppNavigator>();

  GoogleMapController mapController;
  bool keepScreenOn = false;
  AppTheme appTheme;
  AppNavigator appNavigator;
  Logger logger;
  IServiceRouteRepository repository;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    Locator.stop();
    mapController?.dispose();
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
        BlocProvider<TransferBloc>(
          create: (BuildContext context) => TransferBloc(repository: repository, logger: logger),
        ),
      ],
      child: BlocConsumer<TransferBloc, TransferState>(listener: (context, state) {
        if (state is TransferFailState) {
          SnackBarAlert.error(context: context, message: state.reason);
          return;
        }
        mapController.moveCamera(CameraUpdate.newLatLngZoom(state.latLng, state.zoom));
      }, builder: (context, state) {
        var initialState = TransferState.initial();
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            automaticallyImplyLeading: !state.locating,
            title: const Text(AppString.transfer),
            actions: <Widget>[
              Row(
                children: [
                  Text(AppString.keepScreenOn),
                  StatefulBuilder(
                    builder: (context, setState) => Switch(
                      inactiveTrackColor: appTheme.colors.canvasDark,
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
          body: Builder(
            builder: (context) => ContentContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CardTitle(
                    title: widget.serviceRoute.accountDescription,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Expanded(
                    child: Stack(children: [
                      GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: initialState.latLng,
                          zoom: initialState.zoom,
                        ),
                        mapToolbarEnabled: false,
                        buildingsEnabled: false,
                        myLocationEnabled: true,
                        myLocationButtonEnabled: true,
                        markers: state.markers,
                        onMapCreated: onMapCreated,
                      ),
                      buildActionButtons(context, state)
                    ]),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget buildActionButtons(BuildContext context, TransferState state) {
    if (state.locating) {
      return buildTrackingAction(context);
    }
    return buildStartAction(context);
  }

  Widget buildStartAction(BuildContext context) {
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

  Widget buildTrackingAction(BuildContext context) {
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

  Future<void> onStart(BuildContext context) async {
    var locationPermissionGranted = await AppPermission.locationPermissionGranted();
    if (!locationPermissionGranted) {
      await MessageDialog.error(context: context, message: AppString.locationPermissionMustBeGranted);
      return;
    }

    var locationServiceEnable = await AppPermission.locationServiceEnable();
    if (!locationServiceEnable) {
      await MessageDialog.info(context: context, message: AppString.toContinueTurnOnDeviceLocation);
      return;
    }

    Locator.getLocations((newLocation) {
      context.getBloc<TransferBloc>().addRouteLocation(newLocation);
    });

    await Locator.start(
      notificationTitle: AppString.locationInfoCollecting,
      notificationText: AppString.lastLocation,
      updateIntervalInSecond: 10,
    );

    await context.getBloc<TransferBloc>().startLocating();
  }

  Future<void> onStop(
    BuildContext context,
  ) async {
    var result = await MessageSheet.question(
      context: context,
      message: AppString.areYouSureWantToCompleteTransfer,
      buttons: DialogButton.yesNo,
    );
    if (result == DialogResult.yes) {
      await Locator.stop();
      var bloc = context.getBloc<TransferBloc>();

      if (await bloc.fileExist()) {
        await WaitDialog.scope(
          waitMessage: AppString.transferFileUploading,
          context: context,
          call: (_) async => bloc.uploadFile(),
        );
        appNavigator.pop(context, result: true);
      }
    }
  }

  Future<void> onNewPassenger(
    BuildContext context,
  ) async {
    Location newLocation = await Locator.getLastLocation();
    var pointNameResult = await TextInputDialog.show(context, AppString.passengerName);
    String pointName = '';
    if (pointNameResult != null || pointNameResult.dialogResult == DialogResult.ok) {
      pointName = pointNameResult.value;
    }
    await context.getBloc<TransferBloc>().addPointLocation(newLocation, pointName);
  }

  Widget buildButton({
    @required VoidCallback onPressed,
    @required String text,
    @required Color color,
    bool large = false,
  }) {
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
