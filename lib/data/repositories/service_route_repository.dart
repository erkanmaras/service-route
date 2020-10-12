import 'dart:io';

import 'package:service_route/data/data.dart';
import 'package:service_route/domain/domain.dart';

class ServiceRouteRepository extends IServiceRouteRepository {
  ServiceRouteRepository(this.apiClient);
  ServiceRouteApi apiClient;
  @override
  Future<List<ServiceRoute>> getServiceRoutes() {
    return apiClient.getServiceRoutes();
  }

  @override
  Future<List<DeservedRight>> getDeservedRights() {
    return apiClient.getDeservedRights();
  }

  @override
  Future<List<ServiceDocument>> getServiceDocuments() {
    return apiClient.getServiceDocuments();
  }

  @override
  Future<void> uploadServiceRouteFile(File file) {
    return apiClient.uploadServiceRouteFile(file);
  }
}
