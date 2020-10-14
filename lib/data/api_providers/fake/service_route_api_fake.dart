import 'dart:async';
import 'package:dio/dio.dart';
import 'package:service_route/data/api_providers/fake/fake_data.dart';
import 'package:service_route/data/api_providers/service_route_api.dart';
import 'package:service_route/data/data.dart';
import 'package:service_route/infrastructure/infrastructure.dart';

class ServiceRouteApiFake extends ServiceRouteApi {
  ServiceRouteApiFake(AppContext appContext, Logger logger) : super(appContext, logger);

  @override
  void initialize() {
    super.initialize();
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

    if (options.path.contains('service-route')) {
      return dio.resolve<String>(FakeData.serviceRoutes());
    }

    if (options.path.contains('deserved-right')) {
      return dio.resolve<String>(FakeData.deservedRights());
    }

    if (options.path.contains('service-document')) {
      return dio.resolve<String>(FakeData.serviceDocuments());
    }

    if (options.path.contains('upload-route')) {
      return dio.resolve<bool>(true);
    }

        if (options.path.contains('upload-file')) {
      return dio.resolve<bool>(true);
    }
    throw AppError(message: 'FakeData class not configured for this path:${options.path}');
  }
}
