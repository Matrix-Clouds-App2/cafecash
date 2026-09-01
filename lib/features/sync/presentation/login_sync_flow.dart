import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../core/di/injection.dart';
import '../../../core/network/connectivity_service.dart';
import '../../../core/storage/local_storage.dart';
import '../../../core/storage/object_box/object_box_storage.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/default_items_seeder.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/app_confirm_dialog.dart';
import '../../../core/widgets/app_progress_dialog.dart';
import '../../auth/data/auth_repo.dart';
import '../../shift/data/shift_repo.dart';
import '../data/models/bootstrap_merge_plan.dart';
import '../data/sync_repo.dart';
import '../logic/sync_cubit.dart';
import 'widgets/bootstrap_conflict_dialog.dart';

Future<bool> runMandatoryLoginSync(BuildContext context) async {
  while (true) {
    final isOnline = await getIt<ConnectivityService>().isOnline();
    if (!context.mounted) return false;

    if (!isOnline) {
      final retry = await _retryDialog(
        context,
        title: LocaleKeys.sync_loginNeedsInternetTitle.tr(),
        message: LocaleKeys.sync_loginNeedsInternetMessage.tr(),
      );
      if (retry != true) return false;
      continue;
    }

    _wipeLocalDataIfAccountChanged();
    await _uploadPendingShiftsForSameAccount();
    if (!context.mounted) return false;

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
      await cubit.close();
      DefaultItemsSeeder.seedIfCatalogEmpty();
      await _markLocalDataAccount();
      return true;
    }

    await cubit.close();
    if (!context.mounted) return false;

    final retry = await _retryDialog(
      context,
      title: LocaleKeys.sync_loginSyncFailedTitle.tr(),
      message: LocaleKeys.sync_loginSyncFailedMessage.tr(),
    );
    if (retry != true) return false;
  }
}

Future<bool?> _retryDialog(
  BuildContext context, {
  required String title,
  required String message,
}) {
  return AppConfirmDialog.show<bool>(
    context,
    icon: Icons.cloud_off_rounded,
    iconColor: AppColors.warningColor.themeColor,
    title: title,
    message: message,
    confirmLabel: LocaleKeys.sync_retry.tr(),
    cancelLabel: LocaleKeys.sync_cancelLogin.tr(),
    onConfirm: () => Navigator.pop(context, true),
  );
}

int? _currentAccountKey() {
  final user = getIt<AuthRepo>().getCachedProfile();
  if (user == null) return null;
  return user.cafeId ?? user.id;
}

bool _isSameAccountAsLocalData() {
  final key = _currentAccountKey();
  final stored = getIt<LocalStorage>().localDataAccountKey;
  return key != null && stored != null && stored == key;
}

void _wipeLocalDataIfAccountChanged() {
  final key = _currentAccountKey();
  final stored = getIt<LocalStorage>().localDataAccountKey;
  if (key != null && stored != null && stored != key) {
    getIt<ObjectBoxStorage>().wipeAllBusinessData();
  }
}

Future<void> _uploadPendingShiftsForSameAccount() async {
  if (!_isSameAccountAsLocalData()) return;
  final pending = getIt<ShiftRepo>().getUnsyncedClosedShifts();
  for (final shift in pending) {
    try {
      await getIt<SyncRepo>().uploadShift(shift, onProgress: (_) {});
    } catch (_) {}
  }
}

Future<void> _markLocalDataAccount() async {
  final key = _currentAccountKey();
  if (key != null) {
    await getIt<LocalStorage>().setLocalDataAccountKey(key);
  }
}
