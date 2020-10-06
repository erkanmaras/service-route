import 'package:flutter/widgets.dart';

class AppNavigator {
  //
  //  *Fonksiyon isimleri NavigatorMetodName+PageName(Page son eki olmadan)
  //   formatında olmalı.
  //   pushHome ,popLogin ...
  //  *Fonsiyonların dönüş değeri navigator dan dönen future olmalı. (Future<void> bile olsa).

  static final key = GlobalKey<NavigatorState>();
  static final routeObserver = RouteObserver<PageRoute>();
}
