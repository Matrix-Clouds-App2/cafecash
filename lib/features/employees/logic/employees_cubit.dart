import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/network_exceptions.dart';
import '../../../core/utils/app_overlay.dart';
import '../data/employees_repo.dart';
import '../data/models/employee_model.dart';

part 'employees_state.dart';

class EmployeesCubit extends Cubit<EmployeesState> {
  EmployeesCubit(this._repo) : super(const EmployeesInitial());

  final EmployeesRepo _repo;

  Future<void> fetchEmployees() async {
    emit(const EmployeesLoading());
    try {
      final employees = await _repo.getEmployees();
      emit(EmployeesSuccess(employees));
    } catch (e) {
      emit(EmployeesError(_message(e)));
    }
  }

  Future<void> addEmployee({
    required String name,
    required String phone,
    required String email,
  }) async {
    try {
      final employees =
          await _repo.addEmployee(name: name, phone: phone, email: email);
      emit(EmployeesSuccess(employees));
    } catch (e) {
      AppOverlay.showError(_message(e));
    }
  }

  Future<void> updateEmployee({
    required int id,
    required String name,
    required String email,
    required String status,
  }) async {
    try {
      final employees = await _repo.updateEmployee(
        id: id,
        name: name,
        email: email,
        status: status,
      );
      emit(EmployeesSuccess(employees));
    } catch (e) {
      AppOverlay.showError(_message(e));
    }
  }

  Future<void> deleteEmployee(int id) async {
    try {
      final employees = await _repo.deleteEmployee(id);
      emit(EmployeesSuccess(employees));
    } catch (e) {
      AppOverlay.showError(_message(e));
    }
  }

  String _message(Object e) => e is NetworkException ? e.message : e.toString();
}
