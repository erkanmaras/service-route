import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:service_route/ui/ui.dart';

extension BuildContextExtensions on BuildContext {
  T get<T>({bool listen = false}) => Provider.of<T>(this, listen: listen);
  AppTheme getTheme({bool listen = false}) => Provider.of<AppTheme>(this, listen: listen);
  FocusScopeNode getFocusScope() => FocusScope.of(this);
  MediaQueryData getMediaQuery({bool nullOk = false}) => MediaQuery.of(this, nullOk: nullOk);
}
