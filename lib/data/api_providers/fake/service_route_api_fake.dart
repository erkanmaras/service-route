import 'dart:async';
import 'dart:io';
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

  @override
  Future<String> uploadTransferFile(File file) async {
    return '''1,40.9465137,29.1724831,"Başlangıç Noktası",2020-10-30T14:00:22.003302
0,40.9465137,29.1724831
0,40.9462179,29.1723963
0,40.9459027,29.1722587
0,40.9456725,29.1721755
0,40.9453745,29.1720618
0,40.9451344,29.1719562
0,40.9449179,29.1717984
0,40.9447096,29.1716515
1,40.9446022,29.1715858,"erkan maras",2020-10-30T14:01:02.172869
0,40.9444481,29.1714812
0,40.9442256,29.1712661
0,40.9440139,29.1709973
0,40.9438291,29.1707777
0,40.9436374,29.1705089
1,40.9436374,29.1705089,"Bitiş Noktası",2020-10-30T14:01:28.852190''';
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
      if (options.method.equalsIgnoreCase('put')) {
        return dio.resolve<String>(FakeData.uploadTransferFile());
      }
      return dio.resolve<String>(FakeData.transfer());
    }

    if (options.path.contains('monthly-transfer')) {
      return dio.resolve<String>(FakeData.monthlyTransfer());
    }

    if (options.path.contains('upload-file')) {
      return dio.resolve<String>(FakeData.uploadFile());
    }

    if (options.path.contains('documents')) {
      return dio.resolve<String>(FakeData.documents());
    }

    throw AppError(message: 'FakeData class not configured for this path:${options.path}');
  }
}
