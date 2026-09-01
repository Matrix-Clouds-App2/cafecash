import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/router/navigation_services.dart';
import '../../../app/router/routes.dart';
import '../../../core/di/injection.dart';
import '../../../core/network/connectivity_service.dart';
import '../../../core/utils/app_constants.dart';
import '../../../core/utils/app_overlay.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/app_progress_dialog.dart';
import '../../auth/logic/auth_cubit.dart';
import '../../profile/logic/profile_cubit.dart';
import '../../shift/data/shift_repo.dart';
import '../../shift/logic/shift_summary_cubit.dart';
import '../logic/sync_cubit.dart';

Future<void> performLogout({bool isDeleteAccount = false}) async {
  if (!isDeleteAccount && !kIsGuest) {
    await _closeActiveShift();
  }

  NavigationService.pushNamedAndRemoveUntil(Routes.loginScreen);
  WidgetsBinding.instance.addPostFrameCallback((_) {
    final ctx = NavigationService.navigationKey.currentContext!;
    ctx.read<ProfileCubit>().reset();
    ctx.read<AuthCubit>().logout();
  });
}

Future<void> _closeActiveShift() async {
  final shiftRepo = getIt<ShiftRepo>();
  final active = shiftRepo.getActiveShift();
  if (active == null) return;

  final summaryCubit = getIt<ShiftSummaryCubit>()..load(active);
  final summaryState = summaryCubit.state;
  final closingBalance = summaryState is ShiftSummarySuccess
      ? summaryState.summary.closingBalance
      : active.openingBalance;
  await summaryCubit.close();

  shiftRepo.closeShift(active, closingBalance: closingBalance);

  final isOnline = await getIt<ConnectivityService>().isOnline();
  if (!isOnline) {
    AppOverlay.showSuccess(
        LocaleKeys.sync_shiftClosedOfflinePendingUpload.tr());
    return;
  }

  final context = NavigationService.navigationKey.currentContext;
  if (context == null || !context.mounted) return;

  final cubit = getIt<SyncCubit>();
  unawaited(cubit.uploadShift(active));
  await AppProgressDialog.show(context, cubit: cubit);
  if (cubit.state is SyncFailure) {
    AppOverlay.showError(LocaleKeys.sync_uploadFailed.tr());
  }
  await cubit.close();
}
