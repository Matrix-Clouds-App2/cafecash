import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/network_exceptions.dart';
import '../../../core/utils/app_overlay.dart';
import '../../auth/data/models/user_model.dart';
import '../data/settings_repo.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit(this._repo) : super(const SettingsInitial());

  final SettingsRepo _repo;

  Future<void> updateProfile({
    required String name,
    required String email,
    required String phone,
    required String countryCode,
  }) async {
    emit(const UpdateProfileLoading());
    try {
      final user = await _repo.updateProfile(
        name: name,
        email: email,
        phone: phone,
        countryCode: countryCode,
      );
      AppOverlay.showSuccess('تم تحديث البيانات بنجاح');
      emit(UpdateProfileSuccess(user));
    } catch (e) {
      final msg = e is NetworkException ? e.message : e.toString();
      AppOverlay.showError(msg);
      emit(UpdateProfileError(msg));
    }
  }

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    emit(const ChangePasswordLoading());
    try {
      await _repo.changePassword(
        oldPassword: oldPassword,
        newPassword: newPassword,
        newPasswordConfirmation: newPasswordConfirmation,
      );
      AppOverlay.showSuccess('تم تغيير كلمة المرور بنجاح');
      emit(const ChangePasswordSuccess());
    } catch (e) {
      final msg = e is NetworkException ? e.message : e.toString();
      AppOverlay.showError(msg);
      emit(ChangePasswordError(msg));
    }
  }

  Future<void> updatePhoto(String imagePath) async {
    emit(const UpdatePhotoLoading());
    try {
      final user = await _repo.updatePhoto(imagePath);
      AppOverlay.showSuccess('تم تحديث الصورة بنجاح');
      emit(UpdatePhotoSuccess(user));
    } catch (e) {
      final msg = e is NetworkException ? e.message : e.toString();
      AppOverlay.showError(msg);
      emit(UpdatePhotoError(msg));
    }
  }

  void reset() => emit(const SettingsInitial());
}

