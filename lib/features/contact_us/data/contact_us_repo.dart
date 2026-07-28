import 'package:dio/dio.dart';

import '../../../core/network/api_endpoints.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/network/network_exceptions.dart';

class ContactUsRepo {
  ContactUsRepo({required DioClient dio}) : _dio = dio;

  final DioClient _dio;

  Future<void> send({
    required String name,
    required String email,
    required String phone,
    required String message,
  }) async {
    try {
      await _dio.post(ApiEndpoints.contactUs, data: {
        'name': name,
        'email': email,
        'phone': phone,
        'message': message,
      });
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    } catch (e) {
      throw NetworkException(e.toString());
    }
  }
}
