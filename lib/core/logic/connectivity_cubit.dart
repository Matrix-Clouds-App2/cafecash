import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../network/connectivity_service.dart';

part 'connectivity_state.dart';

class ConnectivityCubit extends Cubit<ConnectivityState> {
  ConnectivityCubit(this._service) : super(const ConnectivityOnline());

  final ConnectivityService _service;
  StreamSubscription<bool>? _subscription;

  void watch() {
    _subscription?.cancel();
    _service.isOnline().then((online) {
      if (!isClosed) emit(online ? const ConnectivityOnline() : const ConnectivityOffline());
    });
    _subscription = _service.watch().listen((online) {
      emit(online ? const ConnectivityOnline() : const ConnectivityOffline());
    });
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
