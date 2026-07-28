import 'package:dio/dio.dart';

import '../../../core/network/api_endpoints.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/network/network_exceptions.dart';
import '../../auth/data/models/user_model.dart';

class SettingsRepo {
  SettingsRepo({required DioClient dio}) : _dio = dio;

  final DioClient _dio;

  Future<UserModel> updateProfile({
    required String name,
    required String email,
    required String phone,
    required String countryCode,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.updateProfile,
        data: {
          'name': name,
          'email': email,
          'phone': phone,
          'country_code': countryCode,
        },
      );
      return UserModel.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }

  Future<UserModel> updatePhoto(String imagePath) async {
    try {
      final form = FormData.fromMap({
        'photo': await MultipartFile.fromFile(
          imagePath,
          filename: 'photo.jpg',
        ),
      });
      final response =
          await _dio.postForm(ApiEndpoints.updatePhoto, form);
      return UserModel.fromJson(
          response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    try {
      await _dio.post(
        ApiEndpoints.changePassword,
        data: {
          'old_password': oldPassword,
          'new_password': newPassword,
          'new_password_confirmation': newPasswordConfirmation,
        },
      );
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }
}

