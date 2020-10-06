import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:service_route/data/data.dart';
import 'package:service_route/infrastructure/infrastructure.dart';
import 'package:aff/infrastructure.dart';

class ServiceRouteApi {
  ServiceRouteApi(this.appContext, this.logger);

  final AppContext appContext;
  final Logger logger;
  Dio dio;

  // String get _authorizationToken {
  //   _validateInitialized();
  //   return appContext.user.authToken.token;
  // }

  // Options get _requestOptions {
  //   return Options(headers: <String, dynamic>{
  //     'Authorization': 'Bearer $_authorizationToken'
  //   });
  // }

  void initialize(AuthenticationModel model) {
    dio ??= Dio();
    var baseUrl = model.serverName;
    if (!baseUrl.startsWith('http')) {
      baseUrl = 'http://$baseUrl';
    }

    if (!baseUrl.endsWith('/api/')) {
      baseUrl = '$baseUrl/api/';
    }

    dio.options.baseUrl = baseUrl;
    dio.options.responseType = ResponseType.json;
    dio.options.connectTimeout = 30 * 1000;
    dio.options.receiveTimeout = 30 * 1000;

    var transformer = dio.transformer as DefaultTransformer;
    transformer.jsonDecodeCallback = jsonDecodeAsync;

    if (!kReleaseMode) {
      dio.interceptors.add(LogInterceptor());
    }

    //dio.interceptors.add(AuthorizationTokenRefresh(dio, model));
  }

  // void _validateInitialized() {
  //   dio ??= throw AppError(message: 'V3StoreApi not initialized!');
  // }

  Future<AuthenticationToken> authenticate(AuthenticationModel model) async {
    try {
      final response = await dio.post<String>('login', data: model.toJson());
      return AuthenticationToken.fromJson(
          await jsonDecodeAsync(response.data) as Map<String, dynamic>);
    } catch (e) {
      throw ApiException.fromError(e);
    }
  }


  static dynamic _jsonDecodeCallback(String data) => json.decode(data);

  static Future<dynamic> jsonDecodeAsync(String data) {
    return compute<String, dynamic>(_jsonDecodeCallback, data);
  }
}

class AuthorizationTokenRefresh extends InterceptorsWrapper {
  AuthorizationTokenRefresh(this.dio, this.authModel);
  Dio dio;
  AuthenticationModel authModel;
  @override
  Future onError(DioError err) async {
    // 401 -> token expired
    if (err.response?.statusCode == 401) {
      RequestOptions options = err.request;

      // Lock to block the incoming request until the token updated
      dio.interceptors.requestLock.lock();
      dio.interceptors.responseLock.lock();
      dio.interceptors.errorLock.lock();

      final response =
          await Dio().post<dynamic>('/login', data: authModel.toJson());
      final authenticationToken =
          AuthenticationToken.fromJson(response.data as Map<String, dynamic>)
              as Map<dynamic, String>;
      options.headers['Authorization'] = 'Bearer $authenticationToken.token';
      //Update global token
      dio.interceptors.requestLock.unlock();
      dio.interceptors.responseLock.unlock();
      dio.interceptors.errorLock.unlock();
      return dio.request<dynamic>(options.path, options: options);
    }
    return err;
  }
}

class ApiException extends AppException {
  ApiException({String code, String message})
      : super(code: code, message: message);

  factory ApiException.fromResponse(Response<dynamic> response) {
    var responseMessage = '';
    try {
      var errorModel = ErrorModel.fromJson(
          json.decode(response.data as String) as Map<String, dynamic>);
      switch (errorModel.type) {
        case 'error:sql':
          //bu case de error model de --detail-- alanı dolu.
          //translate edilmeyen sql hataları için unExpectedErrorOccurred yerine
          //başka bir mesaj düşünülebilir mi?
          responseMessage = _ApiStringToAppString.convert(
            errorModel.detail,
            defaultValue: AppString.unExpectedErrorOccurred,
          );
          break;
        case 'login-failed':
          //bu case de error model de  --reasonDescription--  alanı dolu.
          //default value verilmedi, çünkü reasondescription translate edilmemiş
          //ise de kullanıcıya göstermek unExpectedErrorOccurred dan daha mantıklı
          responseMessage =
              _ApiStringToAppString.convert(errorModel.reasonDescription);
          break;
        default:
          responseMessage = AppString.unExpectedErrorOccurred;
      }
    } catch (e) {
      responseMessage = AppString.unExpectedErrorOccurred;
    }
    return ApiException(message: responseMessage);
  }

  //return api exception for known exceptions
  //else return appError with original ex
  static dynamic fromError(dynamic e) {
    if (e is DioError) {
      DioError dioError = e;
      switch (dioError.type) {
        case DioErrorType.CONNECT_TIMEOUT:
        case DioErrorType.RECEIVE_TIMEOUT:
        case DioErrorType.SEND_TIMEOUT:
          return ApiException(message: AppString.apiConnectionTimeout);
          break;
        case DioErrorType.CANCEL:
          return ApiException(message: AppString.apiRequestCanceled);
          break;
        case DioErrorType.RESPONSE:
          return ApiException.fromResponse(dioError.response);
          break;
        case DioErrorType.DEFAULT:
          if (dioError.error is SocketException) {
            return ApiException(
                message: AppString.connectionCouldNotEstablishWithTheServer);
          } else {
            return AppError(innerException: dioError);
          }
          break;
      }
    }

    return ApiException(message: AppString.unExpectedErrorOccurred);
  }
}

class _ApiStringToAppString {
  static Map<String, String> _map = {
    'InvalidUsernameOrPassword': AppString.invalidUserNameOrPassword,
    'Unknown': AppString.authenticationFailed,
  };

  static String convert(String apiString, {String defaultValue}) {
    return _map.containsKey(apiString)
        ? _map[apiString]
        : defaultValue ?? apiString;
  }
}