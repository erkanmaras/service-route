import 'package:service_route/data/data.dart';
import 'package:service_route/domain/domain.dart';

class SettingsRespository extends ISettingsRepository {
  SettingsRespository(this.dbClient);
  final ServiceRouteDb dbClient;

  @override
  Future saveUser(UserSettings user) {
    return dbClient.saveUser(user);
  }

  @override
  Future<UserSettings> getUser() {
    return dbClient.getUser();
  }
}
