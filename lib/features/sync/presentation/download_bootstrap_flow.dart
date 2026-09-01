import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../core/di/injection.dart';
import '../../../core/network/connectivity_service.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_constants.dart';
import '../../../core/utils/app_overlay.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/app_confirm_dialog.dart';
import '../../../core/widgets/app_progress_dialog.dart';
import '../data/models/bootstrap_merge_plan.dart';
import '../logic/sync_cubit.dart';
import 'widgets/bootstrap_conflict_dialog.dart';

Future<void> offerBootstrapDownload(BuildContext context) async {
  if (kIsGuest) return;

  final isOnline = await getIt<ConnectivityService>().isOnline();
  if (!context.mounted || !isOnline) return;

  final wantsDownload = await AppConfirmDialog.show<bool>(
    context,
    icon: Icons.cloud_download_outlined,
    iconColor: AppColors.primaryColor.themeColor,
    title: LocaleKeys.sync_downloadPromptTitle.tr(),
    message: LocaleKeys.sync_downloadPromptMessage.tr(),
    confirmLabel: LocaleKeys.sync_downloadNow.tr(),
    cancelLabel: LocaleKeys.sync_skip.tr(),
    onConfirm: () => Navigator.pop(context, true),
  );
  if (wantsDownload != true) return;
  if (!context.mounted) return;

  final cubit = getIt<SyncCubit>();
  unawaited(cubit.pullBootstrap());
  await AppProgressDialog.show(context, cubit: cubit);

  var state = cubit.state;

  if (state is SyncBootstrapNeedsResolution && context.mounted) {
    final plan = state.plan;
    final choices = await BootstrapConflictDialog.show(
      context,
      conflicts: plan.conflicts,
    );
    await cubit.applyBootstrapResolution(
      plan,
      choices ?? const <String, BootstrapConflictChoice>{},
    );
    state = cubit.state;
  }

  if (state is SyncSuccess) {
    AppOverlay.showSuccess(LocaleKeys.sync_downloadSuccess.tr());
  } else if (state is SyncFailure) {
    AppOverlay.showError(LocaleKeys.sync_downloadFailed.tr());
  }

  await cubit.close();
}
