part of 'customers_cubit.dart';

sealed class CustomersState extends Equatable {
  const CustomersState();

  @override
  List<Object?> get props => [];
}

final class CustomersInitial extends CustomersState {
  const CustomersInitial();
}

final class CustomersLoading extends CustomersState {
  const CustomersLoading();
}

final class CustomersSuccess extends CustomersState {
  final List<CustomerEntity> customers;
  final CustomersSortOption sort;

  const CustomersSuccess(this.customers,
      {this.sort = CustomersSortOption.nameAsc});

  @override
  List<Object?> get props => [customers, sort];
}

final class CustomersError extends CustomersState {
  final String message;

  const CustomersError(this.message);

  @override
  List<Object?> get props => [message];
}
