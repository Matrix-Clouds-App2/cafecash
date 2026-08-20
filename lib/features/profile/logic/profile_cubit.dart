import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/network_exceptions.dart';
import '../../../core/utils/app_constants.dart';
import '../../../core/utils/app_overlay.dart';
import '../../../features/auth/data/auth_repo.dart';
import '../../../features/auth/data/models/user_model.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this._repo) : super(const ProfileInitial());

  final AuthRepo _repo;

  Future<void> getProfile() async {
    final cached = _repo.getCachedProfile();
    if (cached != null) {
      kUserModel = cached;
      emit(ProfileSuccess(cached));
    } else {
      emit(const ProfileLoading());
    }

    try {
      final user = await _repo.getProfile();
      kUserModel = user;
      emit(ProfileSuccess(user));
    } catch (e) {
      if (cached == null) {
        kUserModel = null;
        final msg = e is NetworkException ? e.message : e.toString();
        emit(ProfileError(msg));
      }
    }
  }

  Future<bool> updateName(String name) async {
    try {
      final user = await _repo.updateAccount(name: name);
      kUserModel = user;
      emit(ProfileSuccess(user));
      return true;
    } catch (e) {
      final msg = e is NetworkException ? e.message : e.toString();
      AppOverlay.showError(msg);
      return false;
    }
  }

  Future<bool> deleteAccount() async {
    try {
      await _repo.deleteAccount();
      return true;
    } catch (e) {
      final msg = e is NetworkException ? e.message : e.toString();
      AppOverlay.showError(msg);
      return false;
    }
  }

  void reset() {
    kUserModel = null;
    emit(const ProfileInitial());
  }
}
