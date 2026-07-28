import 'package:get_it/get_it.dart';

import '../../features/auth/data/auth_repo.dart';
import '../../features/auth/logic/auth_cubit.dart';

import '../../features/home/data/home_repo.dart';
import '../../features/home/logic/home_cubit.dart';

import '../../features/profile/logic/profile_cubit.dart';
import '../../features/settings/data/settings_repo.dart';
import '../../features/settings/logic/settings_cubit.dart';
import '../../features/contact_us/data/contact_us_repo.dart';
import '../../features/contact_us/logic/contact_us_cubit.dart';
import '../../features/terms/data/terms_repo.dart';
import '../../features/terms/logic/terms_cubit.dart';

import '../network/dio_client.dart';
import '../storage/local_storage.dart';

final getIt = GetIt.instance;

Future<void> setupDi() async {
  // ─── Storage ──────────────────────────────────────────────────────────────
  getIt.registerLazySingleton(() => LocalStorage());

  // ─── Network ──────────────────────────────────────────────────────────────
  getIt.registerLazySingleton(() => DioClient(storage: getIt()));

  // ─── Repos ────────────────────────────────────────────────────────────────
  getIt.registerLazySingleton(() => AuthRepo(dio: getIt(), storage: getIt()));

  getIt.registerLazySingleton(() => HomeRepo(dio: getIt()));
  getIt.registerLazySingleton(() => SettingsRepo(dio: getIt()));
  getIt.registerLazySingleton(() => ContactUsRepo(dio: getIt()));
  getIt.registerLazySingleton(() => TermsRepo(dio: getIt()));


  // ─── Cubits ───────────────────────────────────────────────────────────────
  getIt.registerFactory(() => AuthCubit(getIt()));
  getIt.registerFactory(() => ProfileCubit(getIt()));

  getIt.registerLazySingleton(() => HomeCubit(getIt()));
  getIt.registerFactory(() => SettingsCubit(getIt()));
  getIt.registerFactory(() => ContactUsCubit(getIt()));
  getIt.registerFactory(() => TermsCubit(getIt()));

}
