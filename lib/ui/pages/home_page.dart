import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:service_route/data/data.dart';
import 'package:service_route/domain/domain.dart';
import 'package:service_route/infrastructure/infrastructure.dart';
import 'package:service_route/ui/ui.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.serviceRoutes}) : super(key: key);

  final List<ServiceRoute> serviceRoutes;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  _HomePageState()
      : navigator = AppService.get<AppNavigator>(),
        appContext = AppService.get<AppContext>();

  final AppNavigator navigator;
  final AppContext appContext;

  AppTheme appTheme;
  Localizer localizer;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    appTheme = context.getTheme();
    localizer = context.getLocalizer();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(localizer.appName),
        ),
        drawer: _MainDrawer(),
        body: ContentContainer(
          child: ListView.separated(
              separatorBuilder: (context, index) => IndentDivider(),
              itemBuilder: (context, index) {
                return Card(
                  elevation: 0,
                  margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  child: ListTile(
                    onTap: () => onTabRoute(widget.serviceRoutes[index]),
                    leading: Icon(AppIcons.roadVariant),
                    title: Text(widget.serviceRoutes[index].description),
                    subtitle: Text('A sufficiently long subtitle'),
                    trailing: Icon(AppIcons.chevronRight),
                  ),
                );
              },
              itemCount: widget.serviceRoutes.length),
        ));
  }

  Future<void> onTabRoute(ServiceRoute selectedServiceRoute) async {
    await openServiceRoutePage(selectedServiceRoute);
  }

  Future<void> openServiceRoutePage(ServiceRoute selectedServiceRoute) async {
    await navigator.pushServiceRoute(context, selectedServiceRoute);
  }
}

class _MainDrawer extends StatelessWidget {
  _MainDrawer()
      : navigator = AppService.get<AppNavigator>(),
        authRepository = AppService.get<IAuthenticationRepository>(),
        logger = AppService.get<Logger>(),
        appContext = AppService.get<AppContext>();

  final AppContext appContext;
  final AppNavigator navigator;
  final IAuthenticationRepository authRepository;
  final Logger logger;
  final String applicationLegalese =
      '''Copyright ©  2020 Öz Ata Tur.\n\nBu paket programların ve kullanım klavuzlarının ilgili telif hakları Fikir ve Sanat Eserlerinin işaretlenmesi hakkındaki yönetmelik hükümleri çercevesinde Öz Ata Tur firmasına aittir.''';

  @override
  Widget build(BuildContext context) {
    final AppTheme appTheme = context.getTheme();
    final Localizer localizer = context.getLocalizer();

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
                              color: appTheme.colors.canvasLight.withOpacity(0.5),
                              size: kMinInteractiveDimension,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5),
                              child: Text(
                                '${appContext.user.userName}',
                                style: appTheme.textStyles.title
                                    .copyWith(color: appTheme.colors.canvasLight.withOpacity(0.5)),
                              ),
                            )
                          ]))),
              ...getDrawerItems(context, appTheme, localizer),
            ]),
          ),
          Container(
              color: appTheme.colors.canvas,
              child: Column(
                children: <Widget>[
                  Divider(),
                  ListTile(
                      leading: Icon(AppIcons.logout, color: appTheme.colors.error),
                      title: Text('Çıkış', style: TextStyle(color: appTheme.colors.error)),
                      onTap: () {
                        navigator.pushAndRemoveUntilLogin(context);
                      })
                ],
              ))
        ]),
      ),
    );
  }

  List<Widget> getDrawerItems(BuildContext context, AppTheme appTheme, Localizer localizer) {
    final List<Widget> drawerItems = <Widget>[];

    drawerItems.add(IndentDivider());
    drawerItems.add(ListTile(
      leading: Icon(AppIcons.informationOutline, color: appTheme.colors.fontPale),
      title: Text('Hak Edişler', style: TextStyle(color: appTheme.colors.fontDark)),
      onTap: () async {
        await navigator.pushDeserveds(context);
      },
    ));

    drawerItems.add(IndentDivider());

    drawerItems.add(ListTile(
      leading: Icon(AppIcons.informationOutline, color: appTheme.colors.fontPale),
      title: Text('Dokümanlar', style: TextStyle(color: appTheme.colors.fontDark)),
      onTap: () async {
        await navigator.pushDocuments(context);
      },
    ));

    drawerItems.add(IndentDivider());

    if (!kReleaseMode) {
      drawerItems.add(ListTile(
        leading: Icon(AppIcons.eye, color: appTheme.colors.fontPale),
        title: Text('Theme Showcase', style: TextStyle(color: appTheme.colors.fontDark)),
        onTap: () {
          navigator.pop(context);
          navigator.pushThemeTest(context);
        },
      ));

      drawerItems.add(IndentDivider());
    }

    drawerItems.add(ListTile(
      leading: Icon(AppIcons.informationOutline, color: appTheme.colors.fontPale),
      title: Text('Hakkında', style: TextStyle(color: appTheme.colors.fontDark)),
      onTap: () async {
        navigator.pop(context);
        var version = await AppInfo.getAppInfo();

        showAboutDialog(
            context: context,
            applicationName: localizer.appName,
            applicationLegalese: applicationLegalese,
            applicationVersion: version.getValue<String>('version'));
      },
    ));

    drawerItems.add(IndentDivider());

    return drawerItems;
  }
}
