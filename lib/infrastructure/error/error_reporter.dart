import 'package:flutter/foundation.dart';
import 'package:aff/infrastructure.dart';
import 'package:service_route/infrastructure/infrastructure.dart';
import 'package:sentry/sentry.dart';

class ErrorReporter {
  static SentryClient sentry;
  static Future<void> initialize() async {
    sentry = SentryClient(dsn: 'https://fe29bb3df9654b2e9c877da0f189fd63@o461639.ingest.sentry.io/5463672');
    var appContext = AppService.tryGet<AppContext>();
    var userIdentifier = appContext == null || appContext.user == null ? 'unknown' : '${appContext.user.userName}';
    sentry.userContext = User(id: userIdentifier);
  }

  static Future<void> sendErrorLog(LogRecord log) async {
    try {
      await sentry.captureException(
        exception: log.message,
        stackTrace: log.stackTrace,
      );
    } catch (e) {
      if (!kReleaseMode) {
        debugPrint(e?.toString() ?? 'ErrorReporter sendErrorLog failed!');
      }
    }
  }

  static Future<void> sendErrorReport(AppErrorReport errorReport) async {
    try {
      await sentry.captureException(
        exception: errorReport.error,
        stackTrace: errorReport.stackTrace,
      );
    } catch (e) {
      if (!kReleaseMode) {
        debugPrint(e?.toString() ?? 'ErrorReporter sendErrorReport failed!');
      }
    }
  }
 
}
