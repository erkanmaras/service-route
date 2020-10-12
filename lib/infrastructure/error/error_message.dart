import 'package:service_route/infrastructure/infrastructure.dart';
import 'package:aff/infrastructure.dart';

class ErrorMessage {
  ErrorMessage._();

  static String get(Object ex) {
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
