import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../app/router/navigation_services.dart';
import '../../app/router/routes.dart';
import '../di/injection.dart';
import '../storage/local_storage.dart';
import '../utils/app_overlay.dart';
import 'api_endpoints.dart';

class DioClient {
  DioClient({required LocalStorage storage}) {
    _dio = _buildDio(storage);
  }

  late final Dio _dio;

  static const Duration _connectTimeout = Duration(seconds: 30);
  static const Duration _receiveTimeout = Duration(seconds: 30);

  Dio _buildDio(LocalStorage storage) {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: _connectTimeout,
        receiveTimeout: _receiveTimeout,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',

          'x-api-key': 'VNxpn4qO45Ug0FgFreLbDU4615nsLS3l',
        },
      ),
    );

    dio.interceptors.addAll([
      _AuthInterceptor(storage),
      _AppLogInterceptor(),
    ]);
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final lang = getIt<LocalStorage>().getLang();

          options.headers['Accept-Language'] = lang;

          return handler.next(options);
        },
      ),
    );
    if (kDebugMode) {
      dio.interceptors.add(PrettyDioLogger(
        requestBody: true,
        requestHeader: true,
        responseBody: true,
        responseHeader: true,
        compact: true,
      ));
    }

    return dio;
  }

  // ─── GET ──────────────────────────────────────────────────────────────────
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) =>
      _dio.get<T>(path, queryParameters: queryParameters, options: options);

  // ─── POST ─────────────────────────────────────────────────────────────────
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) =>
      _dio.post<T>(path, data: data, queryParameters: queryParameters, options: options);

  // ─── PUT ──────────────────────────────────────────────────────────────────
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) =>
      _dio.put<T>(path, data: data, queryParameters: queryParameters, options: options);

  // ─── PATCH ────────────────────────────────────────────────────────────────
  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) =>
      _dio.patch<T>(path, data: data, queryParameters: queryParameters, options: options);

  // ─── DELETE ───────────────────────────────────────────────────────────────
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) =>
      _dio.delete<T>(path, data: data, queryParameters: queryParameters, options: options);

  // ─── POST FormData (images / files) ───────────────────────────────────────
  ///
  /// Example — single image:
  /// ```dart
  /// final form = FormData.fromMap({
  ///   'title': 'My Event',
  ///   'image': await MultipartFile.fromFile('/path/img.jpg', filename: 'img.jpg'),
  /// });
  /// await getIt<DioClient>().postForm('/events', form);
  /// ```
  Future<Response<T>> postForm<T>(
    String path,
    FormData formData, {
    Map<String, dynamic>? queryParameters,
    void Function(int sent, int total)? onSendProgress,
  }) =>
      _dio.post<T>(
        path,
        data: formData,
        queryParameters: queryParameters,
        options: Options(contentType: 'multipart/form-data'),
        onSendProgress: onSendProgress,
      );

  // ─── PUT FormData ─────────────────────────────────────────────────────────
  Future<Response<T>> putForm<T>(
    String path,
    FormData formData, {
    Map<String, dynamic>? queryParameters,
    void Function(int sent, int total)? onSendProgress,
  }) =>
      _dio.put<T>(
        path,
        data: formData,
        queryParameters: queryParameters,
        options: Options(contentType: 'multipart/form-data'),
        onSendProgress: onSendProgress,
      );
}

// ─── Auth Interceptor ─────────────────────────────────────────────────────────

class _AuthInterceptor extends Interceptor {
  _AuthInterceptor(this._storage);
  final LocalStorage _storage;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = _storage.getToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      _storage.clearAll();
      AppOverlay.showError('انتهت صلاحية الجلسة، يرجى تسجيل الدخول مجدداً');
      NavigationService.navigationKey.currentState
          ?.pushNamedAndRemoveUntil(Routes.loginScreen, (_) => false);
    }
    handler.next(err);
  }
}

// ─── Log Interceptor ──────────────────────────────────────────────────────────

class _AppLogInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // ignore: avoid_print
    // print('→ [${options.method}] ${options.uri}');
    // if (options.data != null) {
    //   // ignore: avoid_print
    //   print('   body: ${options.data}');
    // }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // ignore: avoid_print
    print('← [${response.statusCode}] ${response.requestOptions.uri}');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // ignore: avoid_print
    print('✗ [${err.response?.statusCode}] ${err.requestOptions.uri}: ${err.message}');
    handler.next(err);
  }
}
