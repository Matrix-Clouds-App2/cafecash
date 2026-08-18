import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_bottom_sheet.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/custom_tap_effect.dart';
import '../../../hall/data/hall_repo.dart';
import '../../../hall/data/models/hall_table_entity.dart';
import '../../../matches/data/matches_repo.dart';
import '../../../matches/data/models/match_seat_entity.dart';
import '../../../orders/data/models/order_location_kind.dart';
import '../../../orders/presentation/widgets/order_builder_sheet.dart';

class ShiftOccupiedLocationsSheet extends StatelessWidget {
  const ShiftOccupiedLocationsSheet({
    super.key,
    required this.tables,
    required this.seats,
  });

  final List<HallTableEntity> tables;
  final List<MatchSeatEntity> seats;

  static Future<void> show(
    BuildContext context, {
    required List<HallTableEntity> tables,
    required List<MatchSeatEntity> seats,
  }) {
    return AppBottomSheet.show(
      context,
      title: LocaleKeys.shift_occupiedBlockingTitle.tr(),
      child: ShiftOccupiedLocationsSheet(tables: tables, seats: seats),
    );
  }

  void _openTable(BuildContext context, HallTableEntity table) {
    Navigator.pop(context);
    OrderBuilderSheet.show(
      context,
      locationId: table.id,
      locationNumber: table.number,
      kind: OrderLocationKind.table,
      locationLabel: LocaleKeys.hall_tableLabel.tr(),
      syncStatus: ({required occupied, drinkCount = 0, price = 0}) =>
          getIt<HallRepo>().syncOrderSummary(
        tableId: table.id,
        status: occupied ? HallTableStatus.occupied : HallTableStatus.available,
        drinkCount: drinkCount,
        price: price,
      ),
    );
  }

  void _openSeat(BuildContext context, MatchSeatEntity seat) {
    Navigator.pop(context);
    OrderBuilderSheet.show(
      context,
      locationId: seat.id,
      locationNumber: seat.number,
      kind: OrderLocationKind.seat,
      locationLabel: LocaleKeys.matches_seatLabel.tr(),
      syncStatus: ({required occupied, drinkCount = 0, price = 0}) =>
          getIt<MatchesRepo>().syncOrderSummary(
        seatId: seat.id,
        status: occupied ? MatchSeatStatus.occupied : MatchSeatStatus.available,
        drinkCount: drinkCount,
        price: price,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          LocaleKeys.shift_occupiedBlockingMessage.tr(),
          fontSize: 13,
          color: AppColors.textSecondaryColor.themeColor,
        ),
        14.height,
        for (final table in tables)
          Padding(
            padding: EdgeInsets.only(bottom: 10.h),
            child: _LocationTile(
              icon: Icons.table_bar_rounded,
              color: AppColors.secondaryColor.themeColor,
              label: '${LocaleKeys.hall_tableLabel.tr()} ${table.number}',
              onTap: () => _openTable(context, table),
            ),
          ),
        for (final seat in seats)
          Padding(
            padding: EdgeInsets.only(bottom: 10.h),
            child: _LocationTile(
              icon: Icons.event_seat_rounded,
              color: AppColors.accentGold.themeColor,
              label: '${LocaleKeys.matches_seatLabel.tr()} ${seat.number}',
              onTap: () => _openSeat(context, seat),
            ),
          ),
      ],
    );
  }
}

class _LocationTile extends StatelessWidget {
  const _LocationTile({
    required this.icon,
    required this.color,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return CustomTapEffect(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Row(
          children: [
            Container(
              width: 40.r,
              height: 40.r,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.14),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 20.sp),
            ),
            12.width,
            AppText(
              label,
              fontSize: 14.5,
              fontWeight: FontWeight.w700,
              color: color,
            ),
            const Spacer(),
            Icon(Icons.chevron_left_rounded,
                size: 20.sp, color: AppColors.textSecondaryColor.themeColor),
          ],
        ),
      ),
    );
  }
}
