part of 'settings_cubit.dart';

sealed class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object?> get props => [];
}

final class SettingsInitial extends SettingsState {
  const SettingsInitial();
}

// ── Update Profile States ─────────────────────────────────────────────────────

final class UpdateProfileLoading extends SettingsState {
  const UpdateProfileLoading();
}

final class UpdateProfileSuccess extends SettingsState {
  final UserModel user;
  const UpdateProfileSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

final class UpdateProfileError extends SettingsState {
  final String message;
  const UpdateProfileError(this.message);

  @override
  List<Object?> get props => [message];
}

// ── Update Photo States ───────────────────────────────────────────────────────

final class UpdatePhotoLoading extends SettingsState {
  const UpdatePhotoLoading();
}

final class UpdatePhotoSuccess extends SettingsState {
  final UserModel user;
  const UpdatePhotoSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

final class UpdatePhotoError extends SettingsState {
  final String message;
  const UpdatePhotoError(this.message);

  @override
  List<Object?> get props => [message];
}

// ── Change Password States ────────────────────────────────────────────────────

final class ChangePasswordLoading extends SettingsState {
  const ChangePasswordLoading();
}

final class ChangePasswordSuccess extends SettingsState {
  const ChangePasswordSuccess();
}

final class ChangePasswordError extends SettingsState {
  final String message;
  const ChangePasswordError(this.message);

  @override
  List<Object?> get props => [message];
}

