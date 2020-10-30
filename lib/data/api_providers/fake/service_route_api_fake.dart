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

    if (options.path.contains('config')) {
      return dio.resolve<String>(FakeData.config());
    }

    if (options.path.contains('transfer')) {
      if(options.method.equalsIgnoreCase('put'))
      {
        return dio.resolve<String>(FakeData.transfer());
      }
      return dio.resolve<String>(FakeData.transfer());
    }

    if (options.path.contains('monthly-transfer')) {
      return dio.resolve<String>(FakeData.monthlyTransfer());
    }

    if (options.path.contains('upload-route')) {
      return dio.resolve<bool>(true);
    }

    if (options.path.contains('upload-file')) {
      return dio.resolve<String>('filePath');
    }
    throw AppError(message: 'FakeData class not configured for this path:${options.path}');
  }
}
