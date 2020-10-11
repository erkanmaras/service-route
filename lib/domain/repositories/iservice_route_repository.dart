import 'package:service_route/data/data.dart';

abstract class IServiceRouteRepository {
  Future<List<ServiceRoute>> serviceRoutes();
}
