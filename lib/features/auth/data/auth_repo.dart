import 'package:dio/dio.dart';

import '../../../core/network/api_endpoints.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/network/network_exceptions.dart';
import '../../../core/storage/local_storage.dart';
import 'models/user_model.dart';

class AuthRepo {
  AuthRepo({required DioClient dio, required LocalStorage storage})
      : _dio = dio,
        _storage = storage;

  final DioClient _dio;
  final LocalStorage _storage;

  Future<UserModel> login({
    String? email,
    String? phone,
    String? countryCode,
    required String password,
  }) async {
    try {
      final data = <String, dynamic>{
        'password': password,
      };
      if (email != null && email.trim().isNotEmpty) {
        data['email'] = email.trim();
      }
      if (phone != null && phone.trim().isNotEmpty) {
        data['phone'] = phone.trim();
      }
      if (countryCode != null && countryCode.trim().isNotEmpty) {
        data['country_code'] = countryCode.trim();
      }

      final response = await _dio.post(
        ApiEndpoints.login,
        data: data,
      );
      final user = UserModel.fromJson(response.data['data'] as Map<String, dynamic>);
      if (user.token != null) {
        await _storage.setToken(user.token!);
        await _storage.setUser(user.toJson());
      }
      return user;
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }

  Future<UserModel> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String countryCode,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.register,
        data: {
          'name': name,
          'email': email,
          'phone': phone,
          'password': password,
          'country_code': countryCode,
        },
      );
      final user = UserModel.fromJson(response.data['data']['data'] as Map<String, dynamic>);
      if (user.token != null) {
        await _storage.setToken(user.token!);
        await _storage.setUser(user.toJson());
      }
      return user;
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }

  Future<UserModel> getProfile() async {
    try {
      final response = await _dio.get(ApiEndpoints.profile);
      return UserModel.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }

  Future<void> sendFcmToken({
    required String token,
    required String language,
  }) async {
    try {
      await _dio.post(
        ApiEndpoints.fcmToken,
        data: {'token': token, 'language': language},
      );
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }

  Future<void> logout() async {
    try {
      await _dio.post(ApiEndpoints.logout);
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    } finally {
      await _storage.clearAll();
    }
  }
}
