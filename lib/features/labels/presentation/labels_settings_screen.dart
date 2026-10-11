import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/extensions/extensions.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_overlay.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text.dart';
import '../../../core/widgets/app_text_field.dart';
import '../logic/labels_cubit.dart';

class LabelsSettingsScreen extends StatefulWidget {
  const LabelsSettingsScreen({super.key});

  @override
  State<LabelsSettingsScreen> createState() => _LabelsSettingsScreenState();
}

class _LabelsSettingsScreenState extends State<LabelsSettingsScreen> {
  static const _maxLabelLength = 15;

  final _hallCtrl = TextEditingController();
  final _matchesCtrl = TextEditingController();
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final labels = context.read<LabelsCubit>().state;
    _hallCtrl.text = labels.hallLabel ?? '';
    _matchesCtrl.text = labels.matchesLabel ?? '';
  }

  @override
  void dispose() {
    _hallCtrl.dispose();
    _matchesCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    final cubit = context.read<LabelsCubit>();
    await cubit.updateHallLabel(_hallCtrl.text);
    await cubit.updateMatchesLabel(_matchesCtrl.text);
    if (!mounted) return;
    setState(() => _saving = false);
    AppOverlay.showSuccess(LocaleKeys.labels_saveSuccess.tr());
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = AppColors.primaryColor.themeColor;

    return Scaffold(
      backgroundColor: AppColors.surfaceColor.themeColor,
      appBar: AppBar(
        title: Text(LocaleKeys.labels_title.tr()),
        backgroundColor: primaryColor,
        foregroundColor: AppColors.textPrimaryColor.themeColor,
      ),
      body: SingleChildScrollView(
        padding: 24.paddingAll,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              LocaleKeys.labels_maxLengthHint.tr(),
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondaryColor.themeColor,
            ),
            24.height,
            CustomTextField(
              controller: _hallCtrl,
              label: LocaleKeys.labels_hallNameLabel.tr(),
              hint: LocaleKeys.labels_hallNameHint.tr(),
              inputFormatters: [
                LengthLimitingTextInputFormatter(_maxLabelLength),
              ],
              prefixIcon: Icon(
                Icons.table_bar_rounded,
                color: AppColors.textSecondaryColor.themeColor,
                size: 20.sp,
              ),
            ),
            20.height,
            CustomTextField(
              controller: _matchesCtrl,
              label: LocaleKeys.labels_matchesNameLabel.tr(),
              hint: LocaleKeys.labels_matchesNameHint.tr(),
              inputFormatters: [
                LengthLimitingTextInputFormatter(_maxLabelLength),
              ],
              prefixIcon: Icon(
                Icons.sports_soccer_rounded,
                color: AppColors.textSecondaryColor.themeColor,
                size: 20.sp,
              ),
            ),
            28.height,
            CustomButton(
              title: LocaleKeys.common_save.tr(),
              color: primaryColor,
              borderColor: primaryColor,
              textColor: Colors.white,
              loading: _saving,
              onTap: _save,
            ),
          ],
        ),
      ),
    );
  }
}
