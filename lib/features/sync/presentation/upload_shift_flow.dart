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
import '../../shift/data/models/shift_entity.dart';
import '../logic/sync_cubit.dart';

Future<void> offerShiftUpload(BuildContext context, ShiftEntity shift) async {
  if (kIsGuest) return;

  final isOnline = await getIt<ConnectivityService>().isOnline();
  if (!context.mounted) return;

  if (!isOnline) {
    await AppConfirmDialog.show(
      context,
      icon: Icons.cloud_off_rounded,
      iconColor: AppColors.warningColor.themeColor,
      title: LocaleKeys.sync_noInternetTitle.tr(),
      message: LocaleKeys.sync_noInternetForUploadMessage.tr(),
      confirmLabel: LocaleKeys.common_ok.tr(),
      showCancelButton: false,
      onConfirm: () => Navigator.pop(context),
    );
    return;
  }

  final wantsUpload = await AppConfirmDialog.show<bool>(
    context,
    icon: Icons.cloud_upload_outlined,
    iconColor: AppColors.primaryColor.themeColor,
    title: LocaleKeys.sync_uploadPromptTitle.tr(),
    message: LocaleKeys.sync_uploadPromptMessage.tr(),
    confirmLabel: LocaleKeys.sync_uploadNow.tr(),
    cancelLabel: LocaleKeys.sync_skip.tr(),
    onConfirm: () => Navigator.pop(context, true),
  );
  if (wantsUpload != true) return;
  if (!context.mounted) return;

  final cubit = getIt<SyncCubit>();
  unawaited(cubit.uploadShift(shift));
  await AppProgressDialog.show(context, cubit: cubit);

  final state = cubit.state;
  if (state is SyncSuccess) {
    AppOverlay.showSuccess(LocaleKeys.sync_uploadSuccess.tr());
  } else if (state is SyncFailure) {
    AppOverlay.showError(LocaleKeys.sync_uploadFailed.tr());
  }
  await cubit.close();
}
