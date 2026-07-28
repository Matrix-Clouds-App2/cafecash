import 'package:get_it/get_it.dart';

import '../../features/auth/data/auth_repo.dart';
import '../../features/auth/logic/auth_cubit.dart';
import '../../features/profile/logic/profile_cubit.dart';
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

  // ─── Cubits ───────────────────────────────────────────────────────────────
  getIt.registerFactory(() => AuthCubit(getIt()));
  getIt.registerFactory(() => ProfileCubit(getIt()));
}
