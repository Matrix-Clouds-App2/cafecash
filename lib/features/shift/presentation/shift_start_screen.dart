import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../core/utils/app_colors.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/app_top_bar.dart';
import 'widgets/shift_start_view.dart';

/// Reached manually via the drawer's "استلام شيفت" — the exact same form
/// `LayoutScreen` shows inline when there's no active shift, just as its
/// own pushed screen. See [ShiftStartView].
class ShiftStartScreen extends StatelessWidget {
  const ShiftStartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceColor.themeColor,
      body: Column(
        children: [
          AppTopBar(title: LocaleKeys.shift_title.tr()),
          const Expanded(child: ShiftStartView()),
        ],
      ),
    );
  }
}
