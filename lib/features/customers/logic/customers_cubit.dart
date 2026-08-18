import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/app_overlay.dart';
import '../../../core/utils/locale_keys.dart';
import '../data/customers_repo.dart';
import '../data/models/customer_entity.dart';

part 'customers_state.dart';

enum CustomersSortOption { nameAsc, nameDesc, newest, oldest }

class CustomersCubit extends Cubit<CustomersState> {
  CustomersCubit(this._repo) : super(const CustomersInitial());

  final CustomersRepo _repo;
  StreamSubscription<List<CustomerEntity>>? _subscription;

  List<CustomerEntity> _all = [];
  String _query = '';
  CustomersSortOption _sort = CustomersSortOption.nameAsc;

  void fetchCustomers() {
    emit(const CustomersLoading());
    _subscription?.cancel();
    _subscription = _repo.watchAll().listen(
      (customers) {
        _all = customers;
        _emitFiltered();
      },
      onError: (Object e) => emit(CustomersError(e.toString())),
    );
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }

  void addCustomer({required String name, required String phone}) {
    try {
      if (_repo.phoneExists(phone)) {
        AppOverlay.showError(LocaleKeys.customers_phoneExists.tr());
        return;
      }
      _repo.add(name: name, phone: phone);
    } catch (e) {
      AppOverlay.showError(e.toString());
    }
  }

  void updateCustomer(
    CustomerEntity customer, {
    required String name,
    required String phone,
  }) {
    try {
      if (_repo.phoneExists(phone, excludingId: customer.id)) {
        AppOverlay.showError(LocaleKeys.customers_phoneExists.tr());
        return;
      }
      customer
        ..name = name
        ..phone = phone;
      _repo.update(customer);
    } catch (e) {
      AppOverlay.showError(e.toString());
    }
  }

  void deleteCustomer(CustomerEntity customer) {
    try {
      _repo.delete(customer);
    } catch (e) {
      AppOverlay.showError(e.toString());
    }
  }

  void search(String query) {
    _query = query;
    _emitFiltered();
  }

  void sort(CustomersSortOption option) {
    _sort = option;
    _emitFiltered();
  }

  void _emitFiltered() {
    final query = _query.trim().toLowerCase();
    var customers = _all.where((customer) {
      if (query.isEmpty) return true;
      return customer.name.toLowerCase().contains(query) ||
          customer.phone.contains(query);
    }).toList();

    customers.sort((a, b) {
      switch (_sort) {
        case CustomersSortOption.nameAsc:
          return a.name.compareTo(b.name);
        case CustomersSortOption.nameDesc:
          return b.name.compareTo(a.name);
        case CustomersSortOption.newest:
          return (b.createdAt ?? DateTime(0))
              .compareTo(a.createdAt ?? DateTime(0));
        case CustomersSortOption.oldest:
          return (a.createdAt ?? DateTime(0))
              .compareTo(b.createdAt ?? DateTime(0));
      }
    });

    emit(CustomersSuccess(customers, sort: _sort));
  }
}
