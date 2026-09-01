import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../features/sync/data/models/sync_progress.dart';
import '../../features/sync/logic/sync_cubit.dart';
import '../extensions/extensions.dart';
import '../utils/app_colors.dart';
import '../utils/convert_helper.dart';
import '../utils/locale_keys.dart';
import 'app_text.dart';
import 'custom_loading_widget.dart';

class AppProgressDialog extends StatelessWidget {
  const AppProgressDialog({super.key});

  static Future<void> show(BuildContext context, {required SyncCubit cubit}) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: const AppProgressDialog(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: BlocListener<SyncCubit, SyncState>(
        listener: (context, state) {
          if (state is SyncSuccess ||
              state is SyncFailure ||
              state is SyncBootstrapNeedsResolution) {
            Navigator.of(context).pop();
          }
        },
        child: Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
          backgroundColor: AppColors.cardColor.themeColor,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 28.h),
            child: BlocBuilder<SyncCubit, SyncState>(
              builder: (context, state) {
                final progress = state is SyncRunning
                    ? state.progress
                    : const SyncProgress(phase: SyncPhase.preparing);

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!progress.isDeterminate)
                      CustomLoadingWidget(
                        color: AppColors.primaryColor.themeColor,
                        size: 40,
                      )
                    else
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.r),
                        child: LinearProgressIndicator(
                          value: progress.fraction,
                          minHeight: 8.h,
                          color: AppColors.primaryColor.themeColor,
                          backgroundColor: AppColors.dividerColor.themeColor,
                        ),
                      ),
                    18.height,
                    AppText(
                      _phaseLabel(progress.phase),
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimaryColor.themeColor,
                      textAlign: TextAlign.center,
                    ),
                    if (progress.isDeterminate) ...[
                      8.height,
                      AppText(
                        LocaleKeys.sync_ofBytes.tr(namedArgs: {
                          'current': ConvertHelper.formatBytes(progress.current),
                          'total': ConvertHelper.formatBytes(progress.total),
                        }),
                        fontSize: 12.5,
                        color: AppColors.textSecondaryColor.themeColor,
                      ),
                      if (progress.eta != null) ...[
                        4.height,
                        AppText(
                          LocaleKeys.sync_etaLabel.tr(namedArgs: {
                            'time': ConvertHelper.formatEta(progress.eta!),
                          }),
                          fontSize: 12,
                          color: AppColors.textSecondaryColor.themeColor,
                        ),
                      ],
                    ],
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  String _phaseLabel(SyncPhase phase) => switch (phase) {
        SyncPhase.preparing => LocaleKeys.sync_preparing.tr(),
        SyncPhase.compressing => LocaleKeys.sync_compressing.tr(),
        SyncPhase.zippingImages => LocaleKeys.sync_zippingImages.tr(),
        SyncPhase.uploading => LocaleKeys.sync_uploading.tr(),
        SyncPhase.downloading => LocaleKeys.sync_downloading.tr(),
        SyncPhase.merging => LocaleKeys.sync_merging.tr(),
      };
}
