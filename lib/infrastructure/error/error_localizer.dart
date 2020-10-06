 
import 'package:service_route/infrastructure/infrastructure.dart';
import 'package:aff/infrastructure.dart';
class ErrorLocalizer {
  ErrorLocalizer._();

  static String translate(Object ex) {
    //Test içinde null olabiliyor
    if (Localizer.instance == null) {
      return AppString.unExpectedErrorOccurred;
    }

    if (ex is AppErrorReport) {
      if (ex.error is AppException) {
        return Localizer.instance.translate(ex.error.message as String);
      }
    }

    if (ex is AppException) {
      return Localizer.instance.translate(ex.message);
    }

    return Localizer.instance.translate(AppString.unExpectedErrorOccurred);
  }
}
