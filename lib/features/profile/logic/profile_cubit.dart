import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/injection.dart';
import '../../../core/network/network_exceptions.dart';
import '../../../core/storage/local_storage.dart';
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

  Future<void> registerFcmToken() async {
    print('FCM token registration started');

    print('FCM token apns getToken');
    // final messaging = FirebaseMessaging.instance;
    //
    // await messaging.requestPermission();
    //
    // String? apnsToken = await messaging.getAPNSToken();
    //
    // while (apnsToken == null) {
    //   await Future.delayed(const Duration(seconds: 1));
    //   apnsToken = await messaging.getAPNSToken();
    // }
    //
    // print("APNS TOKEN: $apnsToken");
    //
    // final fcmToken = await messaging.getToken();

    // print("FCM TOKEN: $fcmToken");
    final token = await FirebaseMessaging.instance.getToken();
    print('FCM token token $token');
    try {
      // iOS requires the APNs token before Firebase can issue an FCM token.
      // getAPNSToken() waits until APNs is ready (returns null on simulator).

      // if (Platform.isIOS) {
      //   print('FCM token getAPNSToken');
      //
      //   final apns = await FirebaseMessaging.instance.getAPNSToken();
      //   print('FCM token apns ${apns}');
      //
      //   if (apns == null) return;
      // }


      if (token == null) return;

      final language = getIt<LocalStorage>().getLang();
      await _repo.sendFcmToken(token: token, language: language);
    } catch (_) {}
  }
}
