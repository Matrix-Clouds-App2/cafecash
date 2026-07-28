import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/network_exceptions.dart';
import '../../../core/utils/app_overlay.dart';
import '../data/auth_repo.dart';
import '../data/models/user_model.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._repo) : super(const AuthInitial());

  final AuthRepo _repo;

  Future<void> login({
    String? email,
    String? phone,
    String? countryCode,
    required String password,
  }) async {
    emit(const AuthLoading());
    try {
      final user = await _repo.login(
        email: email,
        phone: phone,
        countryCode: countryCode,
        password: password,
      );
      emit(AuthSuccess(user));
    } catch (e) {
      final msg = e is NetworkException ? e.message : e.toString();
      AppOverlay.showError(msg);
      emit(AuthError(msg));
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String countryCode,
  }) async {
    emit(const AuthLoading());
    try {
      final user = await _repo.register(
        name: name,
        email: email,
        phone: phone,
        password: password,
        countryCode: countryCode,
      );
      emit(AuthSuccess(user));
    } catch (e) {
      final msg = e is NetworkException ? e.message : e.toString();
      AppOverlay.showError(msg);
      emit(AuthError(msg));
    }
  }

  Future<void> logout() async {
    // emit(const AuthLoading());
    try {
      await _repo.logout();
      emit(const AuthInitial());
    } catch (e) {
      final msg = e is NetworkException ? e.message : e.toString();
      AppOverlay.showError(msg);
      emit(AuthError(msg));
    }
  }
}
