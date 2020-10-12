import 'dart:io';

import 'package:service_route/data/data.dart';

abstract class IServiceRouteRepository {
  Future<List<ServiceRoute>> getServiceRoutes();
  Future<List<ServiceDocument>> getServiceDocuments();
  Future<List<DeservedRight>> getDeservedRights();
  Future<void> uploadServiceRouteFile(File file);
}
