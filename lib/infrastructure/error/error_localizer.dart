import 'package:service_route/infrastructure/infrastructure.dart';
import 'package:aff/infrastructure.dart';

class ErrorLocalizer {
  ErrorLocalizer._();

  static String translate(Object ex) {
    if (ex is AppErrorReport) {
      if (ex.error is AppException) {
        return (ex.error as AppException).message;
      }
    }

    if (ex is AppException) {
      return ex.message;
    }

    return AppString.anUnExpectedErrorOccurred;
  }
}
