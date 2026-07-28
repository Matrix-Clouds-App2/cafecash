import 'package:dio/dio.dart';

import '../../../core/network/api_endpoints.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/network/network_exceptions.dart';

class TermsRepo {
  TermsRepo({required DioClient dio}) : _dio = dio;

  final DioClient _dio;

  Future<String> fetchTerms() async {
    try {
      final response = await _dio.get(ApiEndpoints.termsConditions);
      final data = response.data['data'] as Map<String, dynamic>;
      return data['terms_and_conditions'] as String? ?? '';
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    } catch (e) {
      throw NetworkException(e.toString());
    }
  }
}
