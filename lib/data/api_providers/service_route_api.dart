import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:service_route/data/data.dart';
import 'package:service_route/data/models/document_edit.dart';
import 'package:service_route/infrastructure/infrastructure.dart';
import 'package:aff/infrastructure.dart';
import 'package:path/path.dart' as path;

class ServiceRouteApi {
  ServiceRouteApi(this.appContext, this.logger);

  final AppContext appContext;
  final Logger logger;
  Dio dio;

  String get _authorizationToken {
    _validateInitialized();
    return appContext.user.authToken.token;
  }

  Options get _requestOptions {
    return Options(headers: <String, dynamic>{'token': '$_authorizationToken'});
  }

  void initialize() {
    dio ??= Dio();
    var baseUrl = 'http://api.servisrotasi.com/api/mobile/';

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

  void _validateInitialized() {
    dio ??= throw AppError(message: 'V3StoreApi not initialized!');
  }

  Future<AuthenticationToken> authenticate(AuthenticationModel model) async {
    var queryParameters = <String, dynamic>{'userName': model.userName, 'password': model.password};
    try {
      final response = await dio.get<String>('login', queryParameters: queryParameters);
      return AuthenticationToken.fromJson(await jsonDecodeAsync(response.data) as Map<String, dynamic>);
    } catch (e) {
      throw ApiException.fromError(e);
    }
  }

  Future<ApplicationSettings> getApplicationSettings() async {
    try {
      final response = await dio.get<String>('config', options: _requestOptions);
      return ApplicationSettings.fromJson(await jsonDecodeAsync(response.data) as Map<String, dynamic>);
    } catch (e) {
      throw ApiException.fromError(e);
    }
  }

  Future<List<TransferRoute>> getTransferRoutes() async {
    try {
      final response = await dio.get<String>('transfer', options: _requestOptions);
      final list = await jsonDecodeAsync(response.data) as List<dynamic>;
      return list.map<TransferRoute>((dynamic model) => TransferRoute.fromJson(model as Map<String, dynamic>)).toList();
    } catch (e) {
      throw ApiException.fromError(e);
    }
  }

  Future<List<CompletedTransfer>> getCompletedTransfers(int year, int mont) async {
    try {
      var queryParameters = <String, dynamic>{'year': year, 'month': mont};
      final response = await dio.get<String>(
        'monthly-transfer',
        queryParameters: queryParameters,
        options: _requestOptions,
      );
      final list = await jsonDecodeAsync(response.data) as List<dynamic>;
      return list
          .map<CompletedTransfer>((dynamic model) => CompletedTransfer.fromJson(model as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ApiException.fromError(e);
    }
  }

  Future<String> uploadTransferFile(File file) async {
    String fileName = path.basename(file.path);
    String fileContent = await file.readAsString();
    FormData formData = FormData.fromMap(<String, MultipartFile>{
      'file': MultipartFile.fromString(fileContent, filename: fileName),
    });
    await dio.put<dynamic>('transfer', data: formData, options: _requestOptions);
    return fileContent;
  }

  Future<void> ediDocuments(DocumentCategory documentCategory, String serverFilePath, String fileName) async {
    var edit = DocumentEdit(filesToAdd: <FilesToAdd>[
      FilesToAdd(
        category: documentCategory.id,
        name: fileName,
        path: serverFilePath,
      )
    ]);
    var data = edit.toJson();
    await dio.post<String>('documents', data: data, options: _requestOptions);
  }

  Future<String> uploadServiceDocumentFile(DocumentFile file) async {
    String fileName = path.basename(file.filePath);
    FormData formData = FormData.fromMap(<String, MultipartFile>{
      'file': await MultipartFile.fromFile(file.filePath, filename: fileName),
    });

    var response = await dio.post<String>('upload-file', data: formData, options: _requestOptions);
    if (response.data.isNullOrWhiteSpace()) {
      throw AppException(message: AppString.documentUploadFail);
    }
    return response.data;
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

      final response = await Dio().post<dynamic>('/login', data: authModel.toJson());
      final authenticationToken =
          AuthenticationToken.fromJson(response.data as Map<String, dynamic>) as Map<dynamic, String>;
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
  ApiException({String code, String message}) : super(code: code, message: message);

  factory ApiException.fromResponse(Response<dynamic> response) {
    var responseMessage = AppString.anUnExpectedErrorOccurred;
    if (response.statusCode == 401) {
      responseMessage = AppString.authenticationFailed;
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
            return ApiException(message: AppString.connectionCouldNotEstablishWithTheServer);
          } else {
            return AppError(innerException: dioError);
          }
          break;
      }
    }

    return ApiException(message: AppString.anUnExpectedErrorOccurred);
  }
}
