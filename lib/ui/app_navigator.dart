import 'package:flutter/material.dart';
import 'package:service_route/data/data.dart';
import 'package:service_route/ui/pages/deserved_rights_page.dart';
import 'package:service_route/ui/pages/document_upload_page.dart';
import 'package:service_route/ui/pages/documents_page.dart';
import 'package:service_route/ui/pages/home_page.dart';
import 'package:service_route/ui/pages/login_page.dart';
import 'package:service_route/ui/pages/route_page.dart';
import 'package:service_route/ui/pages/theme_test_page.dart';

class AppNavigator {
  //
  //  *Fonksiyon isimleri NavigatorMetodName+PageName(Page son eki olmadan)
  //   formatında olmalı.
  //   pushHome ,popLogin ...
  //  *Fonsiyonların dönüş değeri navigator dan dönen future olmalı. (Future<void> bile olsa).

  static final key = GlobalKey<NavigatorState>();
  static final routeObserver = RouteObserver<PageRoute>();
  Future<void> pushAndRemoveUntilLogin(BuildContext context) {
    return Navigator.of(context)
        .pushAndRemoveUntil(MaterialPageRoute<void>(builder: (context) => LoginPage()), (route) => false);
  }

  Future<void> pushAndRemoveUntilHome(BuildContext context, List<ServiceRoute> serviceRoutes) {
    return Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute<void>(builder: (context) => HomePage(serviceRoutes: serviceRoutes)), (route) => false);
  }

  Future<void> pushServiceRoute(BuildContext context, ServiceRoute serviceRoute) {
    return Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (context) => RoutePage(serviceRoute: serviceRoute)));
  }

  Future<void> pushDocuments(BuildContext context) {
    return Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (context) => DocumentsPage()),
    );
  }

  Future<void> pushDocumentUpload(BuildContext context,ServiceDocument serviceDocument) {
    return Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (context) => DocumentUploadPage(serviceDocument :serviceDocument)),
    );
  }

    Future<void> pushDeservedRights(BuildContext context) {
    return Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (context) => DeservedRightsPage()),
    );
  }

  Future<void> pushThemeTest(BuildContext context) {
    return Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (context) => ThemeTestPage()),
    );
  }

  void pop<T extends Object>(BuildContext context, {T result}) {
    Navigator.of(context).pop<T>(result);
  }
}
