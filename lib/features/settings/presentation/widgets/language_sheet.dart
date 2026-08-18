import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/router/routes.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/extensions/extensions.dart';
import '../../../../core/storage/local_storage.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_bottom_sheet.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/custom_tap_effect.dart';

class LanguageSheet {
  LanguageSheet._();

  static Future<void> show(BuildContext context) {
    return AppBottomSheet.show(
      context,
      title: LocaleKeys.settings_languageTitle.tr(),
      child: _LanguageSheetBody(parentContext: context),
    );
  }
}

class _LanguageSheetBody extends StatefulWidget {
  const _LanguageSheetBody({required this.parentContext});

  final BuildContext parentContext;

  @override
  State<_LanguageSheetBody> createState() => _LanguageSheetBodyState();
}

class _LanguageSheetBodyState extends State<_LanguageSheetBody> {
  late String _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.parentContext.locale.languageCode;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _LangOption(
          flag: '🇸🇦',
          label: LocaleKeys.settings_arabic.tr(),
          isSelected: _selected == 'ar',
          onTap: () => setState(() => _selected = 'ar'),
        ),
        12.height,
        _LangOption(
          flag: '🇬🇧',
          label: LocaleKeys.settings_english.tr(),
          isSelected: _selected == 'en',
          onTap: () => setState(() => _selected = 'en'),
        ),
        20.height,
        CustomButton(
          onTap: () async {
            Navigator.pop(context);
            await getIt<LocalStorage>().setLang(_selected);
            if (!widget.parentContext.mounted) return;
            widget.parentContext.setLocale(Locale(_selected));
            Navigator.pushNamedAndRemoveUntil(
              widget.parentContext,
              Routes.splashScreen,
              (_) => false,
            );
          },
          title: LocaleKeys.common_confirm.tr(),
        ),
      ],
    );
  }
}

class _LangOption extends StatelessWidget {
  const _LangOption({
    required this.flag,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String flag;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;

    return CustomTapEffect(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: isSelected
              ? primary.withValues(alpha: 0.06)
              : AppColors.surfaceColor.themeColor,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: isSelected ? primary : AppColors.dividerColor.themeColor,
            width: isSelected ? 1.8 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Text(flag, style: TextStyle(fontSize: 26.sp)),
            14.width,
            AppText(
              label,
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color:
                  isSelected ? primary : AppColors.textPrimaryColor.themeColor,
            ),
            const Spacer(),
            if (isSelected)
              Icon(Icons.check_circle_rounded, color: primary, size: 22.sp)
            else
              Icon(Icons.radio_button_unchecked_rounded,
                  color: AppColors.dividerColor.themeColor, size: 22.sp),
          ],
        ),
      ),
    );
  }
}
