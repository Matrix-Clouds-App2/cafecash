import 'package:dio/dio.dart';

import '../../../core/network/api_endpoints.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/network/network_exceptions.dart';
import 'models/subscription_model.dart';
import 'models/subscription_plan_model.dart';

class SubscriptionRepo {
  SubscriptionRepo({required DioClient dio}) : _dio = dio;

  final DioClient _dio;

  Future<SubscriptionModel?> getCurrentSubscription() async {
    try {
      final response = await _dio.get(ApiEndpoints.subscription);
      final data = response.data['data'] as Map<String, dynamic>;
      final subscription = data['subscription'];
      if (subscription == null) return null;
      return SubscriptionModel.fromJson(subscription as Map<String, dynamic>);
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }

  Future<List<SubscriptionPlanModel>> getPlans() async {
    try {
      final response = await _dio.get(ApiEndpoints.subscriptionPlans);
      final data = response.data['data'] as Map<String, dynamic>;
      final plans = data['plans'] as List? ?? const [];
      return plans
          .map((e) => SubscriptionPlanModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }

  Future<SubscriptionModel?> activate({
    required int cafeId,
    required String planCode,
    String? notes,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.cafeSubscription(cafeId),
        data: {
          'plan_code': planCode,
          if (notes != null && notes.isNotEmpty) 'notes': notes,
        },
      );
      return _subscriptionFromData(response.data);
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }

  Future<SubscriptionModel?> renew({
    required int cafeId,
    required String planCode,
    String? notes,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.cafeSubscriptionRenew(cafeId),
        data: {
          'plan_code': planCode,
          if (notes != null && notes.isNotEmpty) 'notes': notes,
        },
      );
      return _subscriptionFromData(response.data);
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }

  Future<SubscriptionModel?> changePlan({
    required int cafeId,
    required String planCode,
    required String effectiveMode,
    String? notes,
  }) async {
    try {
      final response = await _dio.patch(
        ApiEndpoints.cafeSubscription(cafeId),
        data: {
          'plan_code': planCode,
          'effective_mode': effectiveMode,
          if (notes != null && notes.isNotEmpty) 'notes': notes,
        },
      );
      return _subscriptionFromData(response.data);
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }

  Future<List<SubscriptionModel>> getHistory(int cafeId) async {
    try {
      final response =
          await _dio.get(ApiEndpoints.cafeSubscriptionHistory(cafeId));
      final data = response.data['data'] as Map<String, dynamic>;
      final subscriptions = data['subscriptions'] as List? ?? const [];
      return subscriptions
          .map((e) => SubscriptionModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }

  SubscriptionModel? _subscriptionFromData(dynamic body) {
    final data = body['data'] as Map<String, dynamic>?;
    final subscription = data?['subscription'];
    if (subscription == null) return null;
    return SubscriptionModel.fromJson(subscription as Map<String, dynamic>);
  }
}
