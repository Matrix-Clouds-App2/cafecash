import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/network_exceptions.dart';
import '../../../core/utils/app_constants.dart';
import '../../../features/auth/data/auth_repo.dart';
import '../../../features/auth/data/models/user_model.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this._repo) : super(const ProfileInitial());

  final AuthRepo _repo;

  Future<void> getProfile() async {
    emit(const ProfileLoading());
    try {
      final user = await _repo.getProfile();
      kUserModel = user;
      emit(ProfileSuccess(user));
    } catch (e) {
      // Any profile fetch failure should drop cached user in app-wide guest checks.
      kUserModel = null;
      final msg = e is NetworkException ? e.message : e.toString();
      emit(ProfileError(msg));
    }
  }

  void reset() {
    kUserModel = null;
    emit(const ProfileInitial());
  }
}
