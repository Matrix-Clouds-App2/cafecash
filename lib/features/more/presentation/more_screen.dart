import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/extensions/extensions.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_constants.dart';
import '../../../core/utils/app_images.dart';
import '../../../core/utils/app_overlay.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../profile/logic/profile_cubit.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  final _nameCtrl = TextEditingController(text: kUserModel?.name ?? '');
  bool _saving = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _update() async {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) {
      AppOverlay.showError(LocaleKeys.profile_nameRequired.tr());
      return;
    }

    setState(() => _saving = true);
    final success = await context.read<ProfileCubit>().updateName(name);
    if (!mounted) return;
    setState(() => _saving = false);
    if (success) AppOverlay.showSuccess(LocaleKeys.profile_updateSuccess.tr());
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = AppColors.primaryColor.themeColor;

    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.profile_updateTitle.tr()),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: 24.paddingAll,
        child: Column(
          children: [
            20.height,
            Image.asset(AppImages.visitor, height: 200.h),
            16.height,
            AppText(
              LocaleKeys.profile_updateSubtitle.tr(),
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondaryColor.themeColor,
              textAlign: TextAlign.center,
            ),
            28.height,
            CustomTextField(
              controller: _nameCtrl,
              label: LocaleKeys.profile_nameLabel.tr(),
              hint: LocaleKeys.profile_nameHint.tr(),
              prefixIcon: Icon(
                Icons.person_outline_rounded,
                color: AppColors.textSecondaryColor.themeColor,
                size: 20.sp,
              ),
            ),
            24.height,
            CustomButton(
              title: LocaleKeys.profile_updateButton.tr(),
              color: primaryColor,
              borderColor: primaryColor,
              textColor: Colors.white,
              loading: _saving,
              onTap: _update,
            ),
          ],
        ),
      ),
    );
  }
}
