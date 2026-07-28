import 'package:dio/dio.dart';

class NetworkException implements Exception {
  final String message;
  final int? statusCode;

  const NetworkException(this.message, {this.statusCode});

  factory NetworkException.fromDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkException('Request timed out', statusCode: 408);

      case DioExceptionType.connectionError:
        return const NetworkException('No internet connection', statusCode: 0);

      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final message =
            _extractMessage(e.response?.data) ?? _defaultMessage(statusCode);
        return NetworkException(message, statusCode: statusCode);

      default:
        return const NetworkException('Something went wrong');
    }
  }

  static String? _extractMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data['message'] as String? ??
          data['error'] as String? ??
          data['msg'] as String?;
    }
    return null;
  }

  static String _defaultMessage(int? statusCode) {
    return switch (statusCode) {
      400 => 'Bad request',
      401 => 'Unauthorized',
      403 => 'Forbidden',
      404 => 'Not found',
      422 => 'Validation error',
      500 => 'Internal server error',
      _ => 'Something went wrong',
    };
  }

  @override
  String toString() => message;
}
