import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:service_route/data/data.dart';
import 'package:service_route/domain/bloc/authentication/authentication_state.dart';
import 'package:service_route/domain/domain.dart';
import 'package:service_route/infrastructure/infrastructure.dart';
export 'package:service_route/domain/bloc/authentication/authentication_state.dart';

class AuthenticationBloc extends Cubit<AuthenticationState> {
  AuthenticationBloc({@required this.repository, @required this.appContext, @required this.logger})
      : assert(repository != null),
        assert(logger != null),
        super(AuthenticationInitial());

  final IServiceRouteRepository repository;
  final Logger logger;
  final AppContext appContext;

  Future<void> authentication(
    AuthenticationModel authModel, {
    Future<void> Function() onSuccess,
  }) async {
    try {
      if (authModel.hasEmptyField()) {
        emit(AuthenticationFail(reason: AppString.authenticationParameterMissing));
      } else {
        emit(Authenticating());

        var authToken = await repository.authenticate(authModel);
        appContext.setAppUser(
          authToken,
          authModel.userName,
          authModel.password,
        );

        //onSuccess Authentication işleminde animasyon (progress button) içerisinde ekstra yapılması gereken
        //işlemler için gerekli.
        if (onSuccess != null) {
          await onSuccess();
        }
        emit(AuthenticationSuccess(authToken: authToken, authModel: authModel));
      }
    } on AppException catch (e, s) {
      emit(AuthenticationFail(reason: e.message));
      logger.error(e, stackTrace: s);
    } catch (e, s) {
      emit(AuthenticationFail(reason: AppString.anUnExpectedErrorOccurred));
      logger.error(e, stackTrace: s);
    }
  }

  void logout() {
    emit(AuthenticationInitial());
  }
}
