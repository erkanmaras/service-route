
import 'package:service_route/data/data.dart';
import 'package:service_route/domain/domain.dart';

class AuthenticationRepository extends IAuthenticationRepository {
  AuthenticationRepository(this.apiClient);
  ServiceRouteApi apiClient;

  @override
  Future<AuthenticationToken> authenticate(AuthenticationModel model) async {
      apiClient.initialize( );
      return apiClient.authenticate(model);
  }

}
