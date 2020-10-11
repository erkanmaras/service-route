import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:provider/single_child_widget.dart';
import 'package:aff/infrastructure.dart';
import 'package:service_route/data/data.dart';
import 'package:service_route/ui/pages/login_page.dart';
import 'package:service_route/ui/ui.dart';
import 'package:service_route/domain/domain.dart';
import 'package:service_route/infrastructure/infrastructure.dart';

class App {
  void buildAppServices() {
    AppService.addSingleton<AppContext>(
      AppContext(),
    );

    AppService.addSingleton<Logger>(
      Logger(
          name: 'AppLogger',
          logLevel: LogLevel.error,
          recordStackTraceAtLevel: LogLevel.error),
    );

    AppService.addSingleton<AppNavigator>(
      AppNavigator(),
    );

    AppService.addSingleton<ServiceRouteDb>(
      ServiceRouteDb(),
    );

    AppService.addSingleton<ServiceRouteApi>(
      ServiceRouteApi(AppService.get<AppContext>(), AppService.get<Logger>()),
    );

    AppService.addSingletonFactory<MemoryCache>(
      () => MemoryCache<dynamic, dynamic>(capacity: 1000),
    );

    /////Repositories

    AppService.addTransient<IAuthenticationRepository>(
      () => AuthenticationRepository(AppService.get<ServiceRouteApi>()),
    );

    AppService.addTransient<ISettingsRepository>(
      () => SettingsRespository(AppService.get<ServiceRouteDb>()),
    );

    AppService.addTransient<IServiceRouteRepository>(
      () => ServiceRouteRepository(AppService.get<ServiceRouteApi>()),
    );
  }

  void buildLogListeners() {
    Logger.onLog.listen((log) {
      if (!kReleaseMode) {
        LogDebugPrint.writeLog(log);
        ErrorReporter.sendErrorLog(log);
      } else if (log.level.index >= LogLevel.error.index) {
        ErrorReporter.sendErrorLog(log);
      }
    });
  }

  void setSystemChromeSettings() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }

  Future<void> showError(AppErrorReport appError) async {
    assert(AppNavigator.key.currentState != null, 'Navigator state null!');
    await MessageDialog.error(
      context: AppNavigator.key.currentState.overlay.context,
      title: Localizer.instance?.error ?? AppString.error,
      message: ErrorLocalizer.translate(appError),
    );
  }

  Future<void> reportError(AppErrorReport appError) async {
    await ErrorReporter.sendErrorReport(appError);
  }

  Future<void> initializeUserSettings() async {
    try {
      var userSettings =
          await AppService.get<ISettingsRepository>().getUser().timeout(
                Duration(seconds: 3),
                onTimeout: () =>
                    throw AppError(message: 'Load user setting timeout!'),
              );
      AppService.get<AppContext>().setAppSettings(user: userSettings);
    } catch (e, s) {
      AppService.get<Logger>().error(e, stackTrace: s);
    }
  }

  Future<void> run() async {
    if (kReleaseMode) {
      debugPrint = (message, {wrapWidth}) {};
    }

    AppErrorHandler.onReport = reportError;
    AppErrorHandler.onShow = showError;

    await AppErrorHandler.track(() async {
      WidgetsFlutterBinding.ensureInitialized();
      await ErrorReporter.initialize();
      setSystemChromeSettings();
      buildAppServices();
      buildLogListeners();
      await initializeUserSettings();
      runApp(AppWidget('Servis Rotası'));
    });
  }
}

class AppWidget extends StatelessWidget {
  AppWidget(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [..._providers()],
      builder: (context, child) {
        return addBetaBanner(MaterialApp(
          locale: Locale('tr'),
          localizationsDelegates: _localizationsDelegates(),
          supportedLocales: AppLocalizationsDelegate.supportedLocales,
          title: title,
          builder: _builder,
          navigatorKey: AppNavigator.key,
          navigatorObservers: [AppNavigator.routeObserver],
          home: LoginPage(),
        ));
      },
    );
  }

  Widget _builder(BuildContext context, Widget child) {
    var theme = context.getTheme(listen: true);
    if (!theme.initialized) {
      theme.setTheme(buildWhiteTheme(context));
    }

    return Theme(data: theme.data, child: child);
  }

  Iterable<LocalizationsDelegate<dynamic>> _localizationsDelegates() {
    return [
      AppLocalizationsDelegate(),
      AffLocalizationsDelegate(),
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate
    ];
  }

  List<SingleChildWidget> _providers() {
    Provider.debugCheckInvalidValueType = null;
    return [
      ChangeNotifierProvider<AppTheme>(
        create: (_) => AppTheme(),
      )
    ];
  }

  Widget addBetaBanner(Widget child) {
    return Banner(
      location: kReleaseMode ? BannerLocation.topEnd : BannerLocation.topStart,
      message: 'BETA',
      layoutDirection: TextDirection.ltr,
      textDirection: TextDirection.ltr,
      child: child,
    );
  }
}
