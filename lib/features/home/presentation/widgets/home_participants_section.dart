import 'package:easy_localization/easy_localization.dart';
import 'package:app_base/core/extensions/extensions.dart';
import 'package:app_base/core/utils/app_colors.dart';
import 'package:app_base/core/utils/locale_keys.dart';
import 'package:app_base/core/widgets/app_button.dart';
import 'package:app_base/features/home/presentation/widgets/home_participant_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/widgets/app_text.dart';

class HomeParticipantsSection extends StatelessWidget {
  const HomeParticipantsSection({
    super.key,
    required this.participants,
    this.onCtaTap,
  });

  final List<ParticipantModel> participants;
  final VoidCallback? onCtaTap;

  @override
  Widget build(BuildContext context) {
    if (participants.isEmpty) return const SizedBox.shrink();

    final displayItems = participants.toList();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: 20.paddingHorizontal,
            child: AppText(
              LocaleKeys.home_participantsTitle.tr(),
              fontSize: 14.sp,
              fontWeight: FontWeight.w800,
              color: AppColors.primaryColor.themeColor,
            ),
          ),
          12.verticalSpace,
          Padding(
            padding: 5.paddingHorizontal,
            child: Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: displayItems
                      .map((p) => HomeParticipantCard(participant: p))
                      .toList(),
                ),
              ),
            ),
          ),
          12.verticalSpace,
          Padding(
            padding: 10.paddingHorizontal,
            child: CustomButton(
              title: LocaleKeys.home_participantsCta.tr(),
              onTap: onCtaTap ?? () {},
              color: AppColors.primaryColor.themeColor,
              textColor: Colors.white,
              height: 48,
              customRadius: 18,
            ),
          ),
        ],
      ),
    );
  }
}
