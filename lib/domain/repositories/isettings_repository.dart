
import 'package:service_route/data/data.dart';

abstract class ISettingsRepository {
  Future<void> saveUser(UserSettings user);

  Future<UserSettings> getUser();

}
