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

  /// Returns whether it succeeded — screens navigate to the OTP screen only
  /// on `true`, so a validation/server error just surfaces via
  /// [AppOverlay] and keeps them on the same screen.
  Future<bool> register({required String name, required String phone}) async {
    emit(const AuthLoading());
    try {
      final res = await _repo.register(name: name, phone: phone);

      requestOtp(phone);
      emit(const AuthInitial());
      return true;
    } catch (e) {
      _showError(e);
      return false;
    }
  }

  /// Requests an OTP for [phone] — this is both "login" (no password-based
  /// login endpoint exists) and the OTP screen's "resend code" action.
  Future<bool> requestOtp(String phone) async {
    emit(const AuthLoading());
    try {
      await _repo.resendOtp(phone: phone);
      emit(const AuthInitial());
      return true;
    } catch (e) {
      _showError(e);
      return false;
    }
  }

  Future<bool> verifyOtp({required String phone, required String otp}) async {
    emit(const AuthLoading());
    try {
      final user = await _repo.verifyOtp(phone: phone, otp: otp);
      emit(AuthSuccess(user));
      return true;
    } catch (e) {
      _showError(e);
      return false;
    }
  }

  Future<void> logout() async {
    try {
      await _repo.logout();
      emit(const AuthInitial());
    } catch (e) {
      _showError(e);
    }
  }

  void _showError(Object e) {
    final msg = e is NetworkException ? e.message : e.toString();
    AppOverlay.showError(msg);
    emit(AuthError(msg));
  }
}
