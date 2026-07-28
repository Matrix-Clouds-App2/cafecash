import 'package:easy_localization/easy_localization.dart';
import 'package:app_base/core/utils/app_colors.dart';
import 'package:app_base/core/utils/locale_keys.dart';
import 'package:app_base/core/widgets/app_text.dart';
import 'package:app_base/core/widgets/custom_tap_effect.dart';
import 'package:app_base/features/home/presentation/widgets/home_session_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/router/routes.dart';
import '../../data/models/home_model.dart';

class HomeSessionsSection extends StatefulWidget {
  const HomeSessionsSection({
    super.key,
    required this.forums,
    required this.categories,
  });

  final List<HomeForumModel> forums;
  final List<HomeForumCategoryModel> categories;

  @override
  State<HomeSessionsSection> createState() => _HomeSessionsSectionState();
}

class _HomeSessionsSectionState extends State<HomeSessionsSection> {
  int? _selectedCategoryId;

  List<HomeForumModel> get _filtered {
    if (_selectedCategoryId == null) return widget.forums;
    return widget.forums
        .where((f) => f.category.id == _selectedCategoryId)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;
    final gold = AppColors.accentGold.themeColor;

    if (widget.forums.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppText(
          LocaleKeys.home_todaySessions.tr(),
          fontSize: 14.sp,
          fontWeight: FontWeight.w800,
          color: primary,
        ),
        14.verticalSpace,

        // ── Dynamic filter chips ─────────────────────────────────────────
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _FilterChip(
                label: LocaleKeys.home_filterAll.tr(),
                selected: _selectedCategoryId == null,
                onTap: () => setState(() => _selectedCategoryId = null),
              ),
              ...widget.categories.map((cat) {
                return Padding(
                  padding: EdgeInsets.only(right: 8.w),
                  child: _FilterChip(
                    label: cat.name,
                    selected: _selectedCategoryId == cat.id,
                    onTap: () =>
                        setState(() => _selectedCategoryId = cat.id),
                  ),
                );
              }),
            ],
          ),
        ),
        12.verticalSpace,

        // ── Session cards ────────────────────────────────────────────────
        ..._filtered.asMap().entries.map((e) {
          final stripeColor = e.key.isEven ? primary : gold;
          return CustomTapEffect(
              onTap: (){
                Navigator.pushNamed(
                  context,
                  Routes.forumScheduleDetailsScreen,
                  arguments: {'scheduleId':  e.value.id},
                );
              },
              child: HomeSessionCard(forum: e.value, stripeColor: stripeColor));
        }),
        // 250.verticalSpace,

      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(right: 8.w),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: selected ? primary : Colors.white,
          borderRadius: BorderRadius.circular(999.r),
          border: Border.all(
            color:
                selected ? primary : AppColors.dividerColor.themeColor,
          ),
        ),
        child: AppText(
          label,
          fontSize: 11.sp,
          fontWeight: FontWeight.w700,
          color: selected
              ? Colors.white
              : AppColors.textSecondaryColor.themeColor,
        ),
      ),
    );
  }
}
