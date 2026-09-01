import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/custom_tap_effect.dart';
import '../../data/models/bootstrap_merge_plan.dart';
import 'bootstrap_conflict_tile.dart';

class BootstrapConflictDialog extends StatefulWidget {
  const BootstrapConflictDialog({super.key, required this.conflicts});

  final List<BootstrapConflict> conflicts;

  static Future<Map<String, BootstrapConflictChoice>?> show(
    BuildContext context, {
    required List<BootstrapConflict> conflicts,
  }) {
    return showDialog<Map<String, BootstrapConflictChoice>>(
      context: context,
      barrierDismissible: false,
      builder: (_) => BootstrapConflictDialog(conflicts: conflicts),
    );
  }

  @override
  State<BootstrapConflictDialog> createState() =>
      _BootstrapConflictDialogState();
}

class _BootstrapConflictDialogState extends State<BootstrapConflictDialog> {
  late final Map<String, BootstrapConflictChoice> _choices = {
    for (final c in widget.conflicts) c.uuid: BootstrapConflictChoice.takeServer,
  };

  void _setAll(BootstrapConflictChoice choice) {
    setState(() {
      for (final key in _choices.keys.toList()) {
        _choices[key] = choice;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
        backgroundColor: AppColors.cardColor.themeColor,
        insetPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h),
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 20.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                LocaleKeys.sync_conflictTitle.tr(),
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimaryColor.themeColor,
              ),
              6.height,
              AppText(
                LocaleKeys.sync_conflictSubtitle.tr(),
                fontSize: 12.5,
                color: AppColors.textSecondaryColor.themeColor,
              ),
              14.height,
              Row(
                children: [
                  _bulkButton(
                    LocaleKeys.sync_conflictAllServer.tr(),
                    () => _setAll(BootstrapConflictChoice.takeServer),
                  ),
                  8.width,
                  _bulkButton(
                    LocaleKeys.sync_conflictAllLocal.tr(),
                    () => _setAll(BootstrapConflictChoice.keepLocal),
                  ),
                ],
              ),
              14.height,
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      for (final conflict in widget.conflicts)
                        BootstrapConflictTile(
                          conflict: conflict,
                          choice: _choices[conflict.uuid]!,
                          onChanged: (choice) => setState(
                              () => _choices[conflict.uuid] = choice),
                        ),
                    ],
                  ),
                ),
              ),
              12.height,
              CustomButton(
                onTap: () => Navigator.pop(context, _choices),
                title: LocaleKeys.sync_conflictApply.tr(),
                color: AppColors.primaryColor.themeColor,
                borderColor: AppColors.primaryColor.themeColor,
                textColor: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bulkButton(String label, VoidCallback onTap) {
    return Expanded(
      child: CustomTapEffect(
        onTap: onTap,
        child: Container(
          height: 34.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.backgroundColor.themeColor,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: AppColors.dividerColor.themeColor),
          ),
          child: AppText(
            label,
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.textSecondaryColor.themeColor,
          ),
        ),
      ),
    );
  }
}
