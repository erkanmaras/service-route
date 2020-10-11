import 'package:service_route/data/data.dart';
import 'package:service_route/domain/domain.dart';

class ServiceRouteRepository extends IServiceRouteRepository {
  ServiceRouteRepository(this.apiClient);
  ServiceRouteApi apiClient;
  @override
  Future<List<ServiceRoute>> serviceRoutes() {
    apiClient.initialize();
    return apiClient.serviceRoutes();
  }
}
