 
import 'package:service_route/data/data.dart';

abstract class IAuthenticationRepository {
  Future<AuthenticationToken> authenticate(AuthenticationModel model);
}
