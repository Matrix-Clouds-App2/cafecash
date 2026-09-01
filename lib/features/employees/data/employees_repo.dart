import 'package:dio/dio.dart';

import '../../../core/network/api_endpoints.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/network/network_exceptions.dart';
import 'models/employee_model.dart';

class EmployeesRepo {
  EmployeesRepo({required DioClient dio}) : _dio = dio;

  final DioClient _dio;

  Future<List<EmployeeModel>> getEmployees() async {
    try {
      final response = await _dio.get(ApiEndpoints.employees);
      final data = response.data['data'] as Map<String, dynamic>;
      final employees = data['employees'] as List;
      return employees
          .map((e) => EmployeeModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }

  Future<List<EmployeeModel>> addEmployee({
    required String name,
    required String phone,
    required String email,
  }) async {
    try {
      await _dio.post(
        ApiEndpoints.employees,
        data: {'name': name, 'phone': phone, 'email': email},
      );
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
    return getEmployees();
  }

  Future<List<EmployeeModel>> updateEmployee({
    required int id,
    required String name,
    required String email,
    required String status,
  }) async {
    try {
      await _dio.patch(
        ApiEndpoints.employee(id),
        data: {'name': name, 'email': email, 'status': status},
      );
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
    return getEmployees();
  }

  Future<List<EmployeeModel>> deleteEmployee(int id) async {
    try {
      await _dio.delete(ApiEndpoints.employee(id));
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
    return getEmployees();
  }
}
