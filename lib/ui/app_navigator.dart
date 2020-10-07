import 'package:flutter/material.dart';
import 'package:service_route/ui/pages/home_page.dart';

class AppNavigator {
  //
  //  *Fonksiyon isimleri NavigatorMetodName+PageName(Page son eki olmadan)
  //   formatında olmalı.
  //   pushHome ,popLogin ...
  //  *Fonsiyonların dönüş değeri navigator dan dönen future olmalı. (Future<void> bile olsa).

  static final key = GlobalKey<NavigatorState>();
  static final routeObserver = RouteObserver<PageRoute>();

  Future<void> pushHome(BuildContext context)
  {
    return Navigator.of(context).push(MaterialPageRoute<void>(builder: (context) => HomePage()));
  }
}
