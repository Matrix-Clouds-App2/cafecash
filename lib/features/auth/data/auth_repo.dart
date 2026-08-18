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

  /// Creates the account. Doesn't log the user in by itself — the phone
  /// still has to be confirmed via [verifyOtp] (the server sends the first
  /// OTP as part of registering).
  Future<void> register({
    required String name,
    required String phone,
  }) async {
    try {
      await _dio.post(
        ApiEndpoints.register,
        data: {'name': name, 'phone': phone},
      );
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }

  /// Sends (or re-sends) an OTP to [phone]. This is also how "login" works
  /// for an already-registered phone — there's no separate password-based
  /// login endpoint, just phone + OTP.
  Future<void> resendOtp({required String phone}) async {
    try {
      await _dio.post(
        ApiEndpoints.resendOtp,
        data: {'phone': phone},
      );
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }

  /// Confirms the OTP — this is the call that actually returns the token.
  Future<UserModel> verifyOtp({
    required String phone,
    required String otp,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.verifyOtp,
        data: {'phone': phone, 'otp': otp},
      );
      final data = response.data['data'] as Map<String, dynamic>;
      final user = UserModel.fromJson(
        data['employee'] as Map<String, dynamic>,
        token: data['token'] as String?,
      );
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
      final data = response.data['data'] as Map<String, dynamic>;
      return UserModel.fromJson(data['employee'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }

  /// No dedicated logout endpoint — just drop the local session.
  Future<void> logout() async {
    await _storage.clearAll();
  }
}
