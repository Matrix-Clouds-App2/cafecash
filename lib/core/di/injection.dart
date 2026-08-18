import 'package:get_it/get_it.dart';

import '../../features/auth/data/auth_repo.dart';
import '../../features/auth/logic/auth_cubit.dart';
import '../../features/customers/data/customers_repo.dart';
import '../../features/customers/logic/customers_cubit.dart';
import '../../features/hall/data/hall_repo.dart';
import '../../features/hall/logic/hall_cubit.dart';
import '../../features/items/data/items_repo.dart';
import '../../features/items/logic/categories_cubit.dart';
import '../../features/items/logic/menu_items_cubit.dart';
import '../../features/matches/data/matches_repo.dart';
import '../../features/matches/logic/matches_cubit.dart';
import '../../features/orders/data/orders_repo.dart';
import '../../features/orders/logic/order_cubit.dart';
import '../../features/payments/logic/payments_cubit.dart';
import '../../features/profile/logic/profile_cubit.dart';
import '../../features/shift/data/shift_repo.dart';
import '../../features/shift/logic/shift_cubit.dart';
import '../../features/shift/logic/shift_summary_cubit.dart';
import '../../features/treasury/data/treasury_repo.dart';
import '../../features/treasury/logic/treasury_cubit.dart';
import '../network/dio_client.dart';
import '../storage/local_storage.dart';
import '../storage/object_box/object_box_storage.dart';

final getIt = GetIt.instance;

Future<void> setupDi() async {
  getIt.registerLazySingleton(() => LocalStorage());
  getIt.registerSingleton<ObjectBoxStorage>(await ObjectBoxStorage.create());

  getIt.registerLazySingleton(() => DioClient(storage: getIt()));

  getIt.registerLazySingleton(() => AuthRepo(dio: getIt(), storage: getIt()));
  getIt.registerLazySingleton(() => HallRepo(storage: getIt()));
  getIt.registerLazySingleton(() => MatchesRepo(storage: getIt()));
  getIt.registerLazySingleton(() => ItemsRepo(storage: getIt()));
  getIt.registerLazySingleton(() => OrdersRepo(storage: getIt()));
  getIt.registerLazySingleton(() => TreasuryRepo(storage: getIt()));
  getIt.registerLazySingleton(() => ShiftRepo(storage: getIt()));
  getIt.registerLazySingleton(() => CustomersRepo(storage: getIt()));

  getIt.registerFactory(() => AuthCubit(getIt()));
  getIt.registerFactory(() => ProfileCubit(getIt()));
  getIt.registerFactory(() => HallCubit(getIt()));
  getIt.registerFactory(() => MatchesCubit(getIt()));
  getIt.registerFactory(() => CategoriesCubit(getIt()));
  getIt.registerFactory(() => MenuItemsCubit(getIt()));
  getIt.registerFactory(() => OrderCubit(getIt(), getIt(), getIt()));
  getIt.registerFactory(() => TreasuryCubit(getIt(), getIt()));
  getIt.registerFactory(() => PaymentsCubit(getIt(), getIt()));
  getIt.registerFactory(() => ShiftCubit(getIt()));
  getIt.registerFactory(() => ShiftSummaryCubit(getIt(), getIt()));
  getIt.registerFactory(() => CustomersCubit(getIt()));
}
