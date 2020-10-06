import 'package:flutter/foundation.dart';
import 'package:aff/infrastructure.dart';
import 'package:service_route/infrastructure/infrastructure.dart';
class ErrorReporter {
  static Future<void> initialize() async {
   // await Firebase.initializeApp();
    //await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(kReleaseMode);
  }

  static Future<void> sendErrorLog(LogRecord log) async {
    try {
      await _setGlobals('ErrorLog');
      // await FirebaseCrashlytics.instance.recordError(
      //   log.message,
      //   log.stackTrace,
      // );
    } catch (e) {
      if (!kReleaseMode) {
        debugPrint(e?.toString() ?? 'Crashlytics sendErrorLog failed!');
      }
    }
  }

  static Future<void> sendErrorReport(AppErrorReport errorReport) async {
    try {
      await _setGlobals('ErrorReport');
      // await FirebaseCrashlytics.instance.recordError(
      //   errorReport.error,
      //   errorReport.stackTrace,
      //   information: [errorReport.context],
      //   printDetails: false,
      // );
    } catch (e) {
      if (!kReleaseMode) {
        debugPrint(e?.toString() ?? 'Crashlytics sendErrorReport failed!');
      }
    }
  }

  static Future<void> _setGlobals(String reportType) async {
    var appContext = AppService.tryGet<AppContext>();
    // ignore: unused_local_variable
    var userIdentifier = appContext == null || appContext.user == null
        ? 'unknown'
        : '${appContext.user.userGroupName}\\${appContext.user.userName}';
    // FirebaseCrashlytics instance = FirebaseCrashlytics.instance;
    // await instance.setUserIdentifier(userIdentifier);
    // await instance.setCustomKey('report_type', reportType);
    // await instance.setCustomKey('device_info', jsonEncode(await AppInfo.getDeviceInfo()));
    // await instance.setCustomKey('app_info', jsonEncode(await AppInfo.getAppInfo()));
  }

  //Warning!
  //Exist only for test
  //This method terminates the app
  static Future<void> crash() async {
    // FirebaseCrashlytics.instance.crash();
  }
}
