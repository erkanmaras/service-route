import 'dart:async';
import 'package:dio/dio.dart';
import 'package:service_route/data/api_providers/fake/fake_data.dart';
import 'package:service_route/data/api_providers/service_route_api.dart';
import 'package:service_route/data/data.dart';
import 'package:service_route/infrastructure/infrastructure.dart';

class ServiceRouteApiFake extends ServiceRouteApi {
  ServiceRouteApiFake(AppContext appContext, Logger logger)
      : super(appContext, logger);

  @override
  void initialize(AuthenticationModel model) {
    super.initialize(model);
    dio.interceptors.add(FakeDataInterceptor(dio));
  }
}

class FakeDataInterceptor extends InterceptorsWrapper {
  FakeDataInterceptor(this.dio);

  final Dio dio;

  @override
  Future<dynamic> onRequest(RequestOptions options) async {
    await Future.delayed(Duration(milliseconds: 300), () => null);
    //Sort order imported dont change!!!
    if (options.path.contains('login')) {
      return dio.resolve<String>(FakeData.login());
    }
    throw AppError(
        message: 'FakeData class not configured for this path:${options.path}');
  }
}