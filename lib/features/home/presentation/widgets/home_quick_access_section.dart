import 'package:easy_localization/easy_localization.dart';
import 'package:app_base/core/utils/app_images.dart';
import 'package:app_base/core/utils/locale_keys.dart';
import 'package:app_base/features/home/presentation/widgets/home_quick_access_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../main.dart';

/// Section showing 4 quick-access tiles: Media · Agenda · Map · Exhibitors.
class HomeQuickAccessSection extends StatelessWidget {
  const HomeQuickAccessSection({
    super.key,
    required this.onMediaTap,
    required this.onAgendaTap,
    required this.onMapTap,
    required this.onExhibitorsTap,
    required this.onAssistantTap,
    required this.onHelpTap,
  });

  final VoidCallback onMediaTap;
  final VoidCallback onAgendaTap;
  final VoidCallback onMapTap;
  final VoidCallback onExhibitorsTap;
  final VoidCallback onHelpTap;
  final VoidCallback onAssistantTap;

  @override
  Widget build(BuildContext context) {
    final items = [
      QuickAccessItem(
        image: AppImages.iconsMedia,
        icon: Icons.newspaper_outlined,
        accentColor: AppColors.secondaryColor,
        label: LocaleKeys.media_title2.tr(),
        onTap: onMediaTap,
      ),
      QuickAccessItem(
        image: AppImages.iconsCalendar,
        icon: Icons.calendar_month_outlined,
        accentColor: AppColors.primaryColor,
        label: LocaleKeys.agenda_title2.tr(),
        onTap: onAgendaTap,
      ),
      QuickAccessItem(
        icon: Icons.map_outlined,
        accentColor: AppColors.accentGold,
        label: LocaleKeys.more_map2.tr(),
        onTap: onMapTap,
      ),
      QuickAccessItem(
        icon: Icons.event_note_outlined,
        accentColor: AppColors.successColor,
        label: '${LocaleKeys.more_exhibitors.tr()}\n',
        onTap: onExhibitorsTap,
      ),
      if(isAfterTwoDaysResult)
      QuickAccessItem(
        image: AppImages.iconsChat,
        icon: Icons.message_outlined,
        accentColor: AppColors.secondaryColor,
        label: '${LocaleKeys.nav_assistant.tr()}\n',
        onTap: onHelpTap,
      ),
      QuickAccessItem(
        icon: Icons.videogame_asset,
        accentColor: AppColors.accentGold,
        label: LocaleKeys.more_explore2.tr(),
        onTap: onAssistantTap,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppText(
          LocaleKeys.home_quickAccess.tr(),
          fontSize: 14.sp,
          fontWeight: FontWeight.w800,
          color: AppColors.primaryColor.themeColor,
        ),
        14.verticalSpace,
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(children: [
            ...items.map(
              (item) => HomeQuickAccessItem(item: item),
              // if (item != items.last) 10.horizontalSpace,
            ),
          ]),
        ),
      ],
    );
  }
}
