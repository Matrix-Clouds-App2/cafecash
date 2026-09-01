part of 'employees_cubit.dart';

sealed class EmployeesState extends Equatable {
  const EmployeesState();

  @override
  List<Object?> get props => [];
}

final class EmployeesInitial extends EmployeesState {
  const EmployeesInitial();
}

final class EmployeesLoading extends EmployeesState {
  const EmployeesLoading();
}

final class EmployeesSuccess extends EmployeesState {
  final List<EmployeeModel> employees;

  const EmployeesSuccess(this.employees);

  @override
  List<Object?> get props => [employees];
}

final class EmployeesError extends EmployeesState {
  final String message;

  const EmployeesError(this.message);

  @override
  List<Object?> get props => [message];
}
