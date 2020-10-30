import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
        appNavigator = AppService.get<AppNavigator>(),
        appContext = AppService.get<AppContext>();

  GoogleMapController mapController;
  bool screenLocked = false;
  AppTheme appTheme;
  AppNavigator appNavigator;
  AppContext appContext;
  Logger logger;
  IServiceRouteRepository repository;
  Future<void> wakelockFuture;

  @override
  void initState() {
    wakelockFuture = Wakelock.toggle(enable: true);
    super.initState();
  }

  @override
  void dispose() {
    Wakelock.toggle(enable: false);
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
          create: (BuildContext context) =>
              TransferBloc(transferRouteId: widget.serviceRoute.id, repository: repository, logger: logger),
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
                  FutureBuilder<Object>(
                      future: wakelockFuture,
                      builder: (context, snapshot) {
                        screenLocked = snapshot.connectionState == ConnectionState.done && !snapshot.hasError;
                        return StatefulBuilder(
                          builder: (context, setState) => Switch(
                            inactiveTrackColor: appTheme.colors.canvasDark,
                            value: screenLocked,
                            onChanged: (value) {
                              setState(() {
                                screenLocked = value;
                                Wakelock.toggle(enable: screenLocked);
                              });
                            },
                          ),
                        );
                      }),
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
                        polylines: state.polylines,
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

  int get mapUpdateIntervalInSecond {
    return math.max(appContext.settings.app.mapPointCheckRateInSeconds, 1);
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

    await context.getBloc<TransferBloc>().startLocating(mapUpdateIntervalInSecond);
  }

  Future<void> onStop(BuildContext context) async {
    var bloc = context.getBloc<TransferBloc>();

    if (bloc.locating) {
      var dialogResult = await MessageSheet.question(
        context: context,
        message: AppString.areYouSureWantToCompleteTransfer,
        buttons: DialogButton.yesNo,
      );

      if (dialogResult == DialogResult.no) {
        return;
      }

      await bloc.stopLocating();
    }

    if (!await bloc.fileExist()) {
      //no file no upload
      appNavigator.pop(context, result: false);
    }

    if (!await internetConnectionExist()) {
      await MessageDialog.error(context: context, message: AppString.checkInternetConnectionAndTryAgain);
      return;
    }

    var uploaded = await WaitDialog.scope(
        waitMessage: AppString.transferFileUploading,
        context: context,
        call: (_) async {
          try {
            await bloc.uploadFile();
            return true;
          } catch (e, s) {
            logger.error(e, stackTrace: s);
            return false;
          }
        });

    if (uploaded) {
      appNavigator.pop(context, result: true);
    } else {
      var retryResult = await askRetryQuestion(context);
      if (retryResult == DialogResult.no) {
        appNavigator.pop(context, result: uploaded);
      }
    }
  }

  Future<bool> internetConnectionExist() {
    return Connectivity.checkInternetConnection();
  }

  Future<DialogResult> askRetryQuestion(BuildContext context) {
    AlertDialog alert = AlertDialog(
      title: Text(AppString.error),
      content: Text(AppString.transferFileCannotUpload),
      actions: [
        TextButton(
            // style: TextButton.styleFrom(primary: appTheme.colors.error),
            onPressed: () {
              Navigator.pop(context, DialogResult.no);
            },
            child:
                Text(AppString.exit, style: appTheme.textStyles.subtitleBold.copyWith(color: appTheme.colors.error))),
        TextButton(
            //    style: TextButton.styleFrom(primary: appTheme.colors.primary),
            onPressed: () {
              Navigator.pop(context, DialogResult.yes);
            },
            child: Text(AppString.retry, style: appTheme.textStyles.subtitleBold)),
      ],
    );

    // show the dialog
    return showDialog<DialogResult>(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<void> onNewPassenger(
    BuildContext context,
  ) async {
    var passengerNameResult = await getPassengerName(context, AppString.passengerName);
    String passengerName = '';
    if (passengerNameResult != null || passengerNameResult.dialogResult == DialogResult.ok) {
      passengerName = passengerNameResult.value;
    }
    await context.getBloc<TransferBloc>().addPointLocation(passengerName);
  }

  Future<ValueDialogResult<String>> getPassengerName(BuildContext context, String titleText) async {
    return showDialog<ValueDialogResult<String>>(
      context: context,
      builder: (context) {
        return TextInputDialog(
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[\\w\\s]'))],
          title: Text(titleText),
        );
      },
    );
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
