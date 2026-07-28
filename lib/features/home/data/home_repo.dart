import 'package:dio/dio.dart';

import '../../../core/network/api_endpoints.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/network/network_exceptions.dart';
import 'models/home_model.dart';

class HomeRepo {
  HomeRepo({required DioClient dio}) : _dio = dio;

  final DioClient _dio;

  Future<HomeModel> fetchHome() async {
    try {
      final response = await _dio.get(ApiEndpoints.home);
      return HomeModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }
}
