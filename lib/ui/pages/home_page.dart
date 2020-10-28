import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:service_route/data/data.dart';
import 'package:service_route/domain/domain.dart';
import 'package:service_route/infrastructure/infrastructure.dart';
import 'package:service_route/ui/ui.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.serviceRoutes}) : super(key: key);

  final List<TransferRoute> serviceRoutes;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  _HomePageState()
      : navigator = AppService.get<AppNavigator>(),
        appContext = AppService.get<AppContext>(),
        iserviceRouteRepository = AppService.get<IServiceRouteRepository>();

  final AppNavigator navigator;
  final AppContext appContext;
  IServiceRouteRepository iserviceRouteRepository;
  AppTheme appTheme;
  Future<List<TransferRoute>> transferRoutesFuture;
  List<TransferRoute> transferRoutes;
  @override
  void initState() {
    transferRoutesFuture = iserviceRouteRepository.getTransferRoutes();
    super.initState();
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
          title: Text(AppString.transferList),
        ),
        drawer: _MainDrawer(),
        body: ContentContainer(
            child: FutureBuilder<List<TransferRoute>>(
                future: transferRoutesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return BackgroundHint.loading(context, AppString.loading);
                  } else {
                    if (snapshot.hasError) {
                      return BackgroundHint.unExpectedError(context);
                    } else if (!snapshot.hasData || snapshot.data.isNullOrEmpty()) {
                      return BackgroundHint.noData(context);
                    } else {
                      transferRoutes = snapshot.data;
                      return buildBody();
                    }
                  }
                })));
  }

  Future<void> onTabRoute(BuildContext context, TransferRoute selectedServiceRoute) async {
    var result = await openServiceRoutePage(selectedServiceRoute);
    if (result != null && result == true) {
      SnackBarAlert.info(context: context, message: AppString.transferFileUploaded);
    }
  }

  Future<bool> openServiceRoutePage(TransferRoute selectedServiceRoute) async {
    return navigator.pushTransfer(context, selectedServiceRoute);
  }

  Widget buildBody() {
    return RefreshIndicator(
        color: appTheme.colors.canvasLight,
        backgroundColor: appTheme.colors.primary,
        onRefresh: () async {
          var transferRoutes = await iserviceRouteRepository.getTransferRoutes();
          if (mounted) {
            setState(() => this.transferRoutes = transferRoutes);
          }
        },
        child: ListView.separated(
          separatorBuilder: (context, index) => IndentDivider(),
          itemBuilder: (context, index) {
            var route = transferRoutes[index];
            var leadingIcon = route.completed ? AppIcons.mapMarkerCheckOutline : AppIcons.mapMarkerOutline;
            var leadingIconColor = route.completed ? appTheme.colors.success : appTheme.colors.primary;
            return Card(
              elevation: 0,
              child: ListTile(
                onTap: route.completed ? null : () => onTabRoute(context, route),
                leading: Icon(
                  leadingIcon,
                  color: leadingIconColor,
                ),
                title: Text(route.accountDescription),
                subtitle: Text('${route.lineDescription}\n${ValueFormat.dateTimeToString(route.transferDate)}',
                    style: appTheme.textStyles.body.copyWith(color: appTheme.colors.fontPale)),
                trailing: route.completed
                    ? null
                    : Icon(
                        AppIcons.chevronRight,
                        color: appTheme.colors.primary,
                      ),
              ),
            );
          },
          itemCount: transferRoutes.length,
        ));
  }
}

class _MainDrawer extends StatelessWidget {
  _MainDrawer()
      : navigator = AppService.get<AppNavigator>(),
        repository = AppService.get<IServiceRouteRepository>(),
        logger = AppService.get<Logger>(),
        appContext = AppService.get<AppContext>();

  final AppContext appContext;
  final AppNavigator navigator;
  final IServiceRouteRepository repository;
  final Logger logger;

  @override
  Widget build(BuildContext context) {
    final AppTheme appTheme = context.getTheme();

    return Drawer(
      child: Container(
        color: appTheme.colors.canvasLight,
        child: Column(children: <Widget>[
          Expanded(
            child: ListView(children: <Widget>[
              DrawerHeader(
                  decoration: BoxDecoration(
                    color: appTheme.colors.primary,
                  ),
                  child: SafeArea(
                      bottom: false,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              AppIcons.accountCircle,
                              color: appTheme.colors.canvasLight.withOpacity(0.8),
                              size: kMinInteractiveDimension,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5),
                              child: Text(
                                '${appContext.user.userName}',
                                style: appTheme.textStyles.title
                                    .copyWith(color: appTheme.colors.canvasLight.withOpacity(0.8)),
                              ),
                            )
                          ]))),
              ...getDrawerItems(context, appTheme),
            ]),
          ),
          Container(
              color: appTheme.colors.canvas,
              child: Column(
                children: <Widget>[
                  Divider(),
                  ListTile(
                      leading: Icon(AppIcons.logout, color: appTheme.colors.error),
                      title: Text(AppString.logout,
                          style: appTheme.textStyles.subtitleBold.copyWith(color: appTheme.colors.error)),
                      onTap: () {
                        navigator.pushAndRemoveUntilLogin(context);
                      })
                ],
              ))
        ]),
      ),
    );
  }

  List<Widget> getDrawerItems(BuildContext context, AppTheme appTheme) {
    final List<Widget> drawerItems = <Widget>[];

    drawerItems.add(ListTile(
      leading: Icon(AppIcons.menuRight, color: appTheme.colors.primary),
      title: Text(AppString.completedTransfers, style: appTheme.textStyles.subtitleBold),
      onTap: () async {
        navigator.pop(context);
        await navigator.pushCompletedTransfers(context);
      },
    ));

    drawerItems.add(IndentDivider());

    drawerItems.add(ListTile(
      leading: Icon(AppIcons.menuRight, color: appTheme.colors.primary),
      title: Text(AppString.documents, style: appTheme.textStyles.subtitleBold),
      onTap: () async {
        navigator.pop(context);
        await navigator.pushDocuments(context);
      },
    ));

    if (!kReleaseMode) {
      drawerItems.add(IndentDivider());
      drawerItems.add(ListTile(
        leading: Icon(AppIcons.menuRight, color: appTheme.colors.primary),
        title: Text('Theme Showcase', style: appTheme.textStyles.subtitleBold),
        onTap: () {
          navigator.pop(context);
          navigator.pushThemeTest(context);
        },
      ));

      drawerItems.add(IndentDivider());
    }

    return drawerItems;
  }
}
