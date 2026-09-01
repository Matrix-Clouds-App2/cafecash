import 'dart:async';

import 'package:flutter/widgets.dart';

import '../../../core/di/injection.dart';
import '../../../core/network/connectivity_service.dart';
import '../../../core/utils/app_constants.dart';
import '../../../core/widgets/app_progress_dialog.dart';
import '../../shift/data/models/shift_entity.dart';
import '../logic/sync_cubit.dart';

Future<bool> ensureShiftDetails(BuildContext context, ShiftEntity shift) async {
  if (!shift.remoteOnly) return true;
  if (kIsGuest) return false;

  final isOnline = await getIt<ConnectivityService>().isOnline();
  if (!context.mounted || !isOnline) return false;

  final cubit = getIt<SyncCubit>();
  unawaited(cubit.hydrateShift(shift));
  await AppProgressDialog.show(context, cubit: cubit);
  final ok = cubit.state is SyncSuccess;
  await cubit.close();
  return ok;
}
