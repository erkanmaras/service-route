import 'package:flutter/material.dart';
import 'package:service_route/data/data.dart';
import 'package:service_route/ui/pages/completed_transfers_page.dart';
import 'package:service_route/ui/pages/upload_document_page.dart';
import 'package:service_route/ui/pages/documents_page.dart';
import 'package:service_route/ui/pages/home_page.dart';
import 'package:service_route/ui/pages/login_page.dart';
import 'package:service_route/ui/pages/transfer_page.dart';
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

  Future<void> pushAndRemoveUntilHome(BuildContext context, List<TransferRoute> serviceRoutes) {
    return Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute<void>(builder: (context) => HomePage(serviceRoutes: serviceRoutes)), (route) => false);
  }

  Future<bool> pushServiceRoute(BuildContext context, TransferRoute serviceRoute) {
    return Navigator.of(context)
        .push(MaterialPageRoute<bool>(builder: (context) => TransferPage(serviceRoute: serviceRoute)));
  }

  Future<void> pushDocuments(BuildContext context) {
    return Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (context) => DocumentsPage()),
    );
  }

  Future<void> pushDocumentUpload(BuildContext context,DocumentCategory serviceDocument) {
    return Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (context) => UploadDocumentPage(documentCategory :serviceDocument)),
    );
  }

    Future<void> pushDeservedRights(BuildContext context) {
    return Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (context) => CompletedTransfersPage()),
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
